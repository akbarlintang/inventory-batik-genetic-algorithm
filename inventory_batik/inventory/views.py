from __future__ import division

from django.shortcuts import render
from django.http import Http404
from django.contrib import messages
from django.shortcuts import redirect
from django.http import HttpResponse, JsonResponse
from django.core import serializers
import json
from django.utils import timezone
from datetime import timedelta
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
# from decorators import anonymous_required
from django.contrib.auth.decorators import login_required
from django.db.models import Q
from django.core.serializers import serialize
from django.urls import reverse
from django.db.models import F, Sum
from django.db.models.functions import Coalesce

from .models import *

from .forms import *

# import dependency pso dan periodic review
import pandas as pd
import csv
import numpy as np
import random
import math
from statistics import NormalDist
from scipy.stats import norm
from statistics import stdev
import io, base64
import seaborn as sns
from matplotlib import pyplot as plt
import random
from scipy.integrate import quad
from matplotlib.ticker import FuncFormatter
from datetime import datetime
import time

from django.shortcuts import redirect

def anonymous_required(view_function):
    def wrapper_function(request, *args, **kwargs):
        if request.user.is_authenticated:
            return redirect('dashboard')
        else:
            return view_function(request, *args, **kwargs)
    return wrapper_function


@anonymous_required

def register_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        email    = request.POST['email']

        if len(username) < 1:
            return render(request, 'auth/register.html', {'error': 'Username is required!'})

        if len(email) < 1:
            return render(request, 'auth/register.html', {'error': 'Email is required!'})
        
        # Check if username already exists
        if User.objects.filter(username=username).exists():
            return render(request, 'auth/register.html', {'error': 'Username already exists'})

        # Check if password meets minimum length requirement
        if len(password) < 8:
            return render(request, 'auth/register.html', {'error': 'Password must be at least 8 characters'})
        
        # Hash password
        hashed_password = make_password(password)

        # Create user with hashed password
        user = User.objects.create(username=username, password=hashed_password)
        user.save()

        # Authenticate user
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('dashboard')
        else:
            return render(request, 'auth/register.html', {'error': 'Failed to register user'})
    else:
        return render(request, 'auth/register.html')

@anonymous_required
def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        try:
            user = User.objects.get(username=username)
        except User.DoesNotExist:
            return render(request, 'login.html', {'error': 'Username not found ditemukan'})

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('dashboard')
        else:
            return render(request, 'auth/login.html', {'error': 'Wrong password'})
    else:
        return render(request, 'auth/login.html')

# Dashboard
@login_required
def dashboard_view(request):
    user_id         = request.user.id
    purchases       = Purchase.objects.filter(user_id=user_id)
    sales           = Sales.objects.filter(user_id=user_id)
    products        = Item.objects.filter(type="JADI", user_id=user_id)
    outlets         = Outlet.objects.filter(user_id=user_id)

    purchase_total  = 0
    for p in purchases:
        purchase_total += int(p.price) * int(p.amount)

    sales_total     = 0
    for s in sales:
        sales_total += int(s.price) * int(s.amount)

    product_list = []
    for prod in products:
        product_list.append(prod.name)
    
    context = {
        "purchases_total"     : purchase_total,
        "sales_total"         : sales_total,
        "products"      : products,
        "outlets"       : outlets,
        "product_list"  : product_list
    }

    return render(request, 'dashboard/index.html', context)

@login_required
def logout_view(request):
    logout(request)
    return redirect('login')

def get_sales_data(request):
    # user_id = request.user.id
    outlet_id = request.user.employee.outlet

    # # Ambil tanggal awal bulan ini
    # start_of_month = timezone.now().replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    # # Ambil tanggal awal bulan berikutnya
    # start_of_next_month = (start_of_month + timedelta(days=32)).replace(day=1)

    # # Filter data penjualan hanya untuk bulan ini
    # sales = Sales.objects.filter(created_at__gte=start_of_month, created_at__lt=start_of_next_month, user_id=user_id)

    # Fetch all sales data for the user

    sales = Sales.objects.filter(outlet_id=outlet_id)

    item_sales_count = {}

    for sale in sales:
        item_id = sale.item_id
        item_name = sale.item.name  # Sesuaikan dengan struktur model Anda
        item_sales_count[item_name] = item_sales_count.get(item_name, 0) + int(sale.amount)

    data = {'item_names': list(item_sales_count.keys()), 'sales_counts': list(item_sales_count.values())}
    return JsonResponse(data)

def get_top_sales_data(request):
    outlet_id = request.user.employee.outlet

    sales = Sales.objects.filter(outlet_id=outlet_id)

    item_sales_count = {}

    for sale in sales:
        item_name = sale.item.name
        item_sales_count[item_name] = item_sales_count.get(item_name, 0) + int(sale.amount)

    # Sort by total sales descending and take top 3
    sorted_sales = sorted(item_sales_count.items(), key=lambda x: x[1], reverse=True)[:3]

    # Split into names and counts
    item_names = [item[0] for item in sorted_sales]
    sales_counts = [item[1] for item in sorted_sales]

    data = {
        'item_names': item_names,
        'sales_counts': sales_counts
    }
    return JsonResponse(data)

def get_top_purchases_data(request):
    outlet_id = request.user.employee.outlet

    purchases = Purchase.objects.filter(outlet_id=outlet_id)

    item_purchases_count = {}

    for pruchase in purchases:
        item_name = pruchase.item.name
        item_purchases_count[item_name] = item_purchases_count.get(item_name, 0) + int(pruchase.amount)

    # Sort by total purchases descending and take top 3
    sorted_purchases = sorted(item_purchases_count.items(), key=lambda x: x[1], reverse=True)[:3]

    # Split into names and counts
    item_names = [item[0] for item in sorted_purchases]
    purchases_counts = [item[1] for item in sorted_purchases]

    data = {
        'item_names': item_names,
        'purchases_counts': purchases_counts
    }
    return JsonResponse(data)

def get_purchase_data(request):
    # user_id = request.user.id
    outlet_id = request.user.employee.outlet

    # # Ambil tanggal awal bulan ini
    # start_of_month = timezone.now().replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    # # Ambil tanggal awal bulan berikutnya
    # start_of_next_month = (start_of_month + timedelta(days=32)).replace(day=1)

    # # Filter data pembelian hanya untuk bulan ini
    # purchases = Purchase.objects.filter(created_at__gte=start_of_month, created_at__lt=start_of_next_month)

    purchases = Purchase.objects.filter(outlet_id=outlet_id)

    item_purchases_count = {}

    for purchase in purchases:
        item_id = purchase.item_id
        item_name = purchase.item.name  # Sesuaikan dengan struktur model Anda
        item_purchases_count[item_name] = item_purchases_count.get(item_name, 0) + int(purchase.amount)

    data = {'item_names': list(item_purchases_count.keys()), 'purchases_counts': list(item_purchases_count.values())}
    return JsonResponse(data)

# Outlet
@login_required
def outlet_view(request):
    user_id         = request.user.id
    outlets         = Outlet.objects.filter(user_id=user_id)
    context = {
        'outlets': outlets
    }

    return render(request, 'outlet/index.html', context)

@login_required
def outlet_create_view(request):
    user_id         = request.user.id
    # Mengecek method pada request
    # Jika method-nya adalah POST, maka akan dijalankan
    # proses validasi dan penyimpanan data
    if request.method == 'POST':
       # membuat objek dari class OutletForm
        form = OutletForm(request.POST)
        # Mengecek validasi form
        if form.is_valid():
            # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            new_outlet = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            new_outlet.user_id = user_id
            # Simpan objek outlet baru ke database
            new_outlet.save()
            # mengeset pesan sukses dan redirect ke halaman daftar task
            messages.success(request, 'Outlet added successfully.')
            return redirect('outlet.index')
    # Jika method-nya bukan POST
    else:
        # membuat objek dari class TaskForm
        form = OutletForm()
    # merender template form dengan memparsing data form
    return render(request, 'outlet/form.html', {'form': form})

@login_required
def outlet_update_view(request, outlet_id):
    try:
        # mengambil data outlet yang akan diubah berdasarkan outlet id
        outlet = Outlet.objects.get(pk=outlet_id)
    except Outlet.DoesNotExist:
        # Jika data outlet tidak ditemukan,
        # maka akan di redirect ke halaman 404 (Page not found).
        raise Http404("Outlet not found.")
    # Mengecek method pada request
    # Jika method-nya adalah POST, maka akan dijalankan
    # proses validasi dan penyimpanan data
    if request.method == 'POST':
        form = OutletForm(request.POST, instance=outlet)
        if form.is_valid():
            # Simpan perubahan data ke dalam table outlets
            form.save()
            # mengeset pesan sukses dan redirect ke halaman daftar outlet
            messages.success(request, 'Outlet updated successfully.')
            return redirect('outlet.index')
    # Jika method-nya bukan POST
    else:
        # membuat objek dari class OutletForm
        form = OutletForm(instance=outlet)
    # merender template form dengan memparsing data form
    return render(request, 'outlet/form.html', {'form': form})

@login_required
def outlet_delete_view(request, outlet_id):
    try:
        # mengambil data outlet yang akan dihapus berdasarkan outlet id
        outlet = Outlet.objects.get(pk=outlet_id)
        # menghapus data dari table outlets
        outlet.delete()
        # mengeset pesan sukses dan redirect ke halaman daftar outlet
        messages.success(request, 'Outlet deleted successfully.')
        return redirect('outlet.index')
    except Outlet.DoesNotExist:
        # Jika data outlet tidak ditemukan,
        # maka akan di redirect ke halaman 404 (Page not found).
        raise Http404("Outlet not found.")

def outlet_select_view(request, outlet_id):
    request.session['outlet_id'] = outlet_id

    if outlet_id == 'all':
        request.session['outlet_name'] = 'All Outlets'
    else:
        outlet = Outlet.objects.get(pk=outlet_id)
        request.session['outlet_name'] = outlet.name

    return HttpResponse(True)

def outlet_get_view(request):
    user_id         = request.user.id
    outlets = Outlet.objects.filter(user_id=user_id)
    data = serializers.serialize('json', outlets)
    
    return HttpResponse(data, content_type="text/json-comment-filtered")

def outlet_user_view(request, outlet_id):
    employees = Employee.objects.filter(outlet=outlet_id)
    context = {
        'employees': employees,
        'outlet_id': outlet_id
    }

    return render(request, 'outlet/employee/index.html', context)

def outlet_user_create_view(request, outlet_id):
    if request.method == 'POST':
        form = EmployeeForm(request.POST, outlet_id=outlet_id)
        
        if form.is_valid():
            form.save()
            messages.success(request, 'Employee added successfully.')
            return redirect(reverse('outlet.users.index', kwargs={'outlet_id': outlet_id}))
    else:
        form = EmployeeForm(outlet_id=outlet_id)

    # Render the form template with the form context
    return render(request, 'outlet/employee/form.html', {'form': form})

# Material
@login_required
def material_view(request):
    materials = Material.objects.all()
    context = {
        'materials': materials
    }

    return render(request, 'material/index.html', context)

@login_required
def material_create_view(request):
    # Mengecek method pada request
    # Jika method-nya adalah POST, maka akan dijalankan
    # proses validasi dan penyimpanan data
    user_id         = request.user.id
    if request.method == 'POST':
        # membuat objek dari class TaskForm
        form = MaterialForm(request.POST, request.FILES)
        # Mengecek validasi form
        if form.is_valid():
            # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            new_outlet = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            new_outlet.user_id = user_id
            # Simpan objek outlet baru ke database
            new_outlet.save()
            # mengeset pesan sukses dan redirect ke halaman daftar task
            messages.success(request, 'Material added successfully.')
            return redirect('material.index')
    # Jika method-nya bukan POST
    else:
        # membuat objek dari class TaskForm
        form = MaterialForm()
    # merender template form dengan memparsing data form
    return render(request, 'material/form.html', {'form': form})

@login_required
def material_update_view(request, material_id):
    try:
        material = Material.objects.get(pk=material_id)
    except Material.DoesNotExist:
        raise Http404("Material tidak ditemukan.")
    if request.method == 'POST':
        form = MaterialForm(request.POST, request.FILES, instance=material)
        if form.is_valid():
            form.save()
            messages.success(request, 'Item updated successfully')
            return redirect('material.index')
    else:
        form = MaterialForm(instance=material)
    return render(request, 'material/form.html', {'form': form})

def material_delete_view(request, material_id):
    try:
        material = Material.objects.get(pk=material_id)
        material.delete()
        messages.success(request, 'Material deleted successfully.')
        return redirect('material.index')
    except Material.DoesNotExist:
        raise Http404("Material not found.")
    
# Product
@login_required
def product_view(request):
    outlet_id = request.user.employee.outlet_id
    items = Item.objects.filter(type="JADI").annotate(
        total_stock=Coalesce(Sum('stock__amount', filter=F('stock__outlet_id') == outlet_id), 0)
    )

    context = {
        'items': items
    }

    return render(request, 'product/index.html', context)

def product_create_view(request):
    # Mengecek method pada request
    # Jika method-nya adalah POST, maka akan dijalankan
    # proses validasi dan penyimpanan data
    user_id         = request.user.id

    if request.method == 'POST':
        if request.user.employee.role == "superadmin":
            form = ItemForm(request.POST, request.FILES)
        else:
            form = OutletItemForm(request.POST, request.FILES)
        
        # Mengecek validasi form
        if form.is_valid():
             # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            new_outlet = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            new_outlet.user_id = user_id
            # Simpan objek outlet baru ke database
            new_outlet.save()
            # mengeset pesan sukses dan redirect ke halaman daftar task
            messages.success(request, 'Item added successfully.')
            return redirect('product.index')
    # Jika method-nya bukan POST
    else:
        # membuat objek dari class TaskForm
        form = ItemForm()
    # merender template form dengan memparsing data form
    return render(request, 'product/form.html', {'form': form})

@login_required
def product_update_view(request, product_id):
    try:
        item = Item.objects.get(pk=product_id)
    except Item.DoesNotExist:
        raise Http404("Item tidak ditemukan.")
    
    if request.method == 'POST':
        if request.user.employee.role == "superadmin":
            form = ItemForm(request.POST, request.FILES, instance=item)
        else:
            form = OutletItemEditForm(request.POST, request.FILES, instance=item)
        
        if form.is_valid():
            form.save()
            messages.success(request, 'Item updated successfully.')
            return redirect('product.index')
    else:
        if request.user.employee.role == "superadmin":
            form = ItemForm(instance=item)
        else:
            form = OutletItemEditForm(instance=item)
    return render(request, 'product/form.html', {'form': form})

def product_delete_view(request, product_id):
    try:
        item = Item.objects.get(pk=product_id)
        item.delete()
        messages.success(request, 'Item deleted successfully.')
        return redirect('product.index')
    except Item.DoesNotExist:
        raise Http404("Item not found.")
    
# Product recipe
@login_required
def product_recipe_view(request, product_id):
    items = Recipe.objects.filter(item_id=product_id)
    product = Item.objects.get(pk=product_id)
    context = {
        'items': items,
        'product': product
    }

    return render(request, 'product_recipe/index.html', context)

@login_required
def product_recipe_create_view(request, product_id):
    # Mengecek method pada request
    # Jika method-nya adalah POST, maka akan dijalankan
    # proses validasi dan penyimpanan data
    if request.method == 'POST':
        # membuat objek dari class TaskForm
        form = RecipeForm(request.POST, request.FILES)
        # Mengecek validasi form
        if form.is_valid():
            # Membuat Task baru dengan data yang disubmit
            new_task = form.save(commit=False)
            new_task.item_id = product_id
            # Simpan data ke dalam table tasks
            new_task.save()
            # mengeset pesan sukses dan redirect ke halaman daftar task
            messages.success(request, 'Recipe added successfully.')
            return redirect('product.recipe.index', product_id)
    # Jika method-nya bukan POST
    else:
        # membuat objek dari class TaskForm
        form = RecipeForm()
    # merender template form dengan memparsing data form
    return render(request, 'product_recipe/form.html', {'form': form, 'product_id': product_id})

def product_recipe_delete_view(request, product_id, material_id):
    try:
        recipe = Recipe.objects.filter(item_id=product_id).filter(material_id=material_id)
        recipe.delete()
        messages.success(request, 'Recipe deleted successfully.')
        return redirect('product.recipe.index', product_id)
    except Recipe.DoesNotExist:
        raise Http404("Recipe not found.")

# Purchase
@login_required
def purchase_view(request):
    outlet_id         = request.user.employee.outlet
    start_date = request.GET.get('start_date')
    end_date = request.GET.get('end_date')

    # if request.session.has_key('outlet_id'):
    #     if request.session['outlet_id'] == 'all':
    #         purchases = Purchase.objects.filter(user_id=user_id).order_by('-created_at')
    #     else:
    #         purchases = Purchase.objects.filter(user_id=user_id).order_by('-created_at')
    # else:
    #     purchases = Purchase.objects.filter(user_id=user_id)

    # if request.user.employee.role == 'admin':
    #     purchases = Purchase.objects.filter(outlet_id=outlet_id).order_by('-created_at')
    # else:
    #     purchases = Purchase.objects.order_by('-created_at')

    purchases = Purchase.objects.filter(outlet_id=outlet_id).order_by('-created_at')

    # Filter by date range if provided
    if start_date:
        try:
            start_date = datetime.strptime(start_date, '%Y-%m-%d')  # Convert to datetime
            sales = sales.filter(created_at__gte=start_date)
        except ValueError:
            pass  # Handle invalid date format if necessary
    
    if end_date:
        try:
            end_date = datetime.strptime(end_date, '%Y-%m-%d')  # Convert to datetime
            sales = sales.filter(created_at__lte=end_date)
        except ValueError:
            pass  # Handle invalid date format if necessary
    
    context = {
        'purchases': purchases,
        'start_date': start_date,
        'end_date': end_date,
    }

    return render(request, 'purchase/index.html', context)

@login_required
def purchase_create_view(request):
    user_id         = request.user.id
    if request.method == 'POST':
        form = PurchaseForm(request.POST)
        if form.is_valid():
            # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            temp = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            temp.user_id = user_id
            # Simpan objek outlet baru ke database
            temp.save()

            # Simpan transaction dari purchase
            Transaction.objects.create(
                item_id = request.POST.get('item',''),
                outlet_id = request.POST.get('outlet',''),
                purchase_id = temp.id,
                user_id = user_id,
                type = 'purchase'
            )

            messages.success(request, 'Purchases added successfully.')
            return redirect('purchase.index')
    else:
        form = PurchaseForm()
    return render(request, 'purchase/form.html', {'form': form})

@login_required
def purchase_update_view(request, purchase_id):
    try:
        purchase = Purchase.objects.get(pk=purchase_id)
    except Purchase.DoesNotExist:
        raise Http404("Purchases not found.")
    if request.method == 'POST':
        form = PurchaseForm(request.POST, instance=purchase)
        if form.is_valid():
            form.save()
            messages.success(request, 'Purchases updated successfully.')
            return redirect('purchase.index')
    else:
        form = PurchaseForm(instance=purchase)
    return render(request, 'purchase/form.html', {'form': form})

def purchase_delete_view(request, purchase_id):
    try:
        purchase = Purchase.objects.get(pk=purchase_id)
        purchase.delete()
        messages.success(request, 'Purchases deleted successfully.')
        return redirect('purchase.index')
    except Purchase.DoesNotExist:
        raise Http404("Purchases not found.")

# Production
@login_required
def production_view(request):
    outlet_id         = request.user.employee.outlet
    # if request.session.has_key('outlet_id'):
    #     if request.session['outlet_id'] == 'all':
    #         productions = Production.objects.filter(user_id=user_id).order_by('-created_at')
    #     else:
    #         productions = Production.objects.objects.filter(user_id=user_id).order_by('-created_at')
    # else:
    #     productions = Production.objects.filter(user_id=user_id)

    if request.user.employee.role == 'admin':
        productions = Production.objects.filter(outlet_id=outlet_id).order_by('-created_at')
    else:
        productions = Production.objects.order_by('-created_at')

    context = {
        'productions': productions
    }

    return render(request, 'production/index.html', context)

@login_required
def production_create_view(request):
    user_id         = request.user.id
    if request.method == 'POST':
        form = ProductionForm(request.POST)
        if form.is_valid():
            # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            temp = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            temp.user_id = user_id
            # Simpan objek outlet baru ke database
            temp.save()

            # Simpan stock dari production
            try:
                obj = Stock.objects.get(outlet=request.POST.get('outlet',''), item=request.POST.get('item',''))
                obj.amount = int(obj.amount) + int(request.POST.get('amount',''))
                obj.save()
            except Stock.DoesNotExist:
                Stock.objects.create(
                    item_id = request.POST.get('item',''),
                    outlet_id = request.POST.get('outlet',''),
                    amount = request.POST.get('amount',''),
                    user_id = user_id
                )

            messages.success(request, 'Production added successfully.')
            return redirect('production.index')
    else:
        form = ProductionForm()
    return render(request, 'production/form.html', {'form': form})

def production_update_view(request, production_id):
    try:
        production = Production.objects.get(pk=production_id)
    except Production.DoesNotExist:
        raise Http404("Production not found.")
    if request.method == 'POST':
        form = ProductionForm(request.POST, instance=production)
        if form.is_valid():
            # prod = Production.objects.get(id=form.id)
            return HttpResponse(request.POST.get('pk',''))
            temp = form.save()

            # Simpan stock dari production
            try:
                obj = Stock.objects.get(outlet=request.POST.get('outlet',''), item=request.POST.get('item',''))
                return HttpResponse(prod.amount)
                obj.amount = int(obj.amount) - int(prod.amount) + int(request.POST.get('amount',''))
                obj.save()
            except Stock.DoesNotExist:
                Stock.objects.create(
                    item_id = request.POST.get('item',''),
                    outlet_id = request.POST.get('outlet',''),
                    amount = request.POST.get('amount',''),
                )
            
            messages.success(request, 'Sukses Mengubah Produksi.')
            return redirect('production.index')
    else:
        form = ProductionForm(instance=production)
    return render(request, 'production/form.html', {'form': form})

def production_delete_view(request, production_id):
    try:
        production = Production.objects.get(pk=production_id)
        production.delete()
        messages.success(request, 'Production deleted successfully.')
        return redirect('production.index')
    except Production.DoesNotExist:
        raise Http404("Production not found.")

# Sales
@login_required
def sales_view(request):
    outlet_id         = request.user.employee.outlet
    start_date = request.GET.get('start_date')
    end_date = request.GET.get('end_date')

    # if request.session.has_key('outlet_id'):
        # if request.session['outlet_id'] == 'all':
        #     sales = Sales.objects.filter(user_id=user_id).order_by('-created_at')
        # else:
        #     sales = Sales.objects.filter(user_id=user_id).order_by('-created_at')
    # else:
    #     sales = Sales.objects.filter(user_id=user_id).order_by('-created_at')

    # if request.user.employee.role == 'admin':
    #     sales = Sales.objects.filter(outlet_id=outlet_id).order_by('-created_at')
    # else:
    #     sales = Sales.objects.order_by('-created_at')

    sales = Sales.objects.filter(outlet_id=outlet_id).order_by('-created_at')

    # Filter by date range if provided
    if start_date:
        try:
            start_date = datetime.strptime(start_date, '%Y-%m-%d')  # Convert to datetime
            sales = sales.filter(created_at__gte=start_date)
        except ValueError:
            pass  # Handle invalid date format if necessary
    
    if end_date:
        try:
            end_date = datetime.strptime(end_date, '%Y-%m-%d')  # Convert to datetime
            sales = sales.filter(created_at__lte=end_date)
        except ValueError:
            pass  # Handle invalid date format if necessary
    
    context = {
        'sales': sales,
        'start_date': start_date,
        'end_date': end_date,
    }

    return render(request, 'sales/index.html', context)

@login_required
def sales_create_view(request):
    user_id         = request.user.id
    if request.method == 'POST':
        form = SalesForm(request.POST)
        if form.is_valid():
             # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            temp = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            temp.user_id = user_id
            # Simpan objek outlet baru ke database
            temp.save()

            # Simpan transaction dari sales
            Transaction.objects.create(
                item_id = request.POST.get('item',''),
                outlet_id = request.POST.get('outlet',''),
                sales_id = temp.id,
                type = 'sales',
                user_id = user_id
            )

            # Simpan stock dari production
            try:
                obj = Stock.objects.get(outlet=request.POST.get('outlet',''), item=request.POST.get('item',''))
                obj.amount = int(obj.amount) - int(request.POST.get('amount',''))
                obj.save()
            except Stock.DoesNotExist:
                Stock.objects.create(
                    item_id = request.POST.get('item',''),
                    outlet_id = request.POST.get('outlet',''),
                    amount = request.POST.get('amount',''),
                    user_id = user_id
                )

            messages.success(request, 'Sales added successfully.')
            return redirect('sales.index')
    else:
        form = SalesForm()
    return render(request, 'sales/form.html', {'form': form})

@login_required
def sales_update_view(request, sales_id):
    try:
        sales = Sales.objects.get(pk=sales_id)
    except Sales.DoesNotExist:
        raise Http404("Sales not found.")
    if request.method == 'POST':
        form = SalesForm(request.POST, instance=sales)
        if form.is_valid():
            form.save()

            # Simpan stock dari production
            try:
                obj = Stock.objects.get(outlet=request.POST.get('outlet',''), item=request.POST.get('item',''))
                obj.amount = int(obj.amount) - int(request.POST.get('amount',''))
                obj.save()
            except Stock.DoesNotExist:
                Stock.objects.create(
                    item_id = request.POST.get('item',''),
                    outlet_id = request.POST.get('outlet',''),
                    amount = request.POST.get('amount',''),
                )

            messages.success(request, 'Sales updated successfully.')
            return redirect('sales.index')
    else:
        form = SalesForm(instance=sales)
    return render(request, 'sales/form.html', {'form': form})

def sales_delete_view(request, sales_id):
    try:
        sales = Sales.objects.get(pk=sales_id)
        sales.delete()
        messages.success(request, 'Sales deleted successfully.')
        return redirect('sales.index')
    except Sales.DoesNotExist:
        raise Http404("Sales not found.")

# Transaction
@login_required
def transaction_view(request):
    outlet_id         = request.user.employee.outlet
    start_date = request.GET.get('start_date')
    end_date = request.GET.get('end_date')
    # if request.session.has_key('outlet_id'):
    #     if request.session['outlet_id'] == 'all':
    #         transactions = Transaction.objects.filter(user_id=user_id).order_by('-created_at')
    #     else:
    #         transactions = Transaction.objects.filter(user_id=user_id).order_by('-created_at')
    # else:
    #     transactions = Transaction.objects.filter(user_id=user_id).order_by('-created_at')

    if request.user.employee.role == 'admin':
        transactions = Transaction.objects.filter(outlet_id=outlet_id).order_by('-created_at')
    else:
        transactions = Transaction.objects.order_by('-created_at')
    
    # Filter by date range if provided
    if start_date:
        try:
            start_date = datetime.strptime(start_date, '%Y-%m-%d')  # Convert to datetime
            transactions = transactions.filter(created_at__gte=start_date)
        except ValueError:
            pass  # Handle invalid date format if necessary
    
    if end_date:
        try:
            end_date = datetime.strptime(end_date, '%Y-%m-%d')  # Convert to datetime
            transactions = transactions.filter(created_at__lte=end_date)
        except ValueError:
            pass  # Handle invalid date format if necessary
    
    context = {
        'transactions': transactions,
        'start_date': start_date,
        'end_date': end_date,
    }

    return render(request, 'transaction/index.html', context)

# Stocks
@login_required
def stock_view(request):
    user_id         = request.user.id
    if request.session.has_key('outlet_id'):
        if request.session['outlet_id'] == 'all':
            stocks = Stock.objects.filter(user_id=user_id)
        else:
            stocks = Stock.objects.filter(user_id=user_id)
    else:
        stocks = Stock.objects.filter(user_id=user_id)
    
    context = {
        'stocks': stocks
    }

    return render(request, 'stock/index.html', context)

# Export
@login_required
def export_view(request):
    user_id         = request.user.id
    if request.method == 'POST':
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="ExportData.csv"'        
        writer = csv.writer(response)
        writer.writerow(['Sales Data'])
        writer.writerow(['No', 'Nama Barang','Biaya Pesan','Permintaan Bahan Baku','Biaya Simpan','Biaya Kekurangan','Harga Produk','Lead Time Pemenuhan', 'Standar Deviasi'])
        items = Item.objects.filter(type="JADI", user_id=user_id).all()
        for idx, item in enumerate(items):
            sales = Sales.objects.filter(user_id=user_id).filter(item_id=item.id)

            # return HttpResponse(len(sales))
            sales_count = 0
            sales_list = []

            for sale in sales:
                sales_count += sale.amount
                sales_list.append(sale.amount)

            n = len(sales_list)
            if n < 2:
                if not sales:
                    standar_deviasi = 1
                else:
                    standar_deviasi = sales[0].amount
            else:
                standar_deviasi = np.std(sales_list)

            biaya_kekurangan = round((item.price * 7.5 / 100) + item.price)

            # Write row excel
            row = [idx+1, item.name, item.biaya_pesan, sales_count, 20000, biaya_kekurangan, item.price, item.lead_time, standar_deviasi]
            writer.writerow(row)
        return response
    
    context = {
        # 'transactions': transactions
    }

    return render(request, 'export/index.html', context)

def daily_demand(mean, sd, zero_threshold_factor=1.0):
    """Return a stochastic daily demand value (may be 0)."""
    random_num = np.random.uniform(0, 1)
    if random_num < zero_threshold_factor:
        return 0
    return max(0, np.random.normal(mean, sd)) * 2
 
 
def simulate_inventory(product):
    product_sim = {k: product[k] for k in product}
 
    daily_mean = product["permintaan_baku"] / 60
    daily_sd   = product["standar_deviasi"] / np.sqrt(60)
 
    demand_list  = []
    total_demand = 0
 
    for _ in range(60):
        d = daily_demand(daily_mean, daily_sd, 0.5)
        if d > 0:
            total_demand += d
        demand_list.append(d)
 
    product_sim["permintaan_baku"] = round(total_demand)
    product_sim["standar_deviasi"] = np.std(demand_list)
 
    return product_sim, demand_list
 
 
# ---------------------------------------------------------------------------
# Periodic-review analytical formulas
# ---------------------------------------------------------------------------
 
def per_review(product, demand):
    """EOQ-based periodic-review formula. Returns (total_cost, review_interval)."""
    to = math.sqrt(
        (2 * product["biaya_pesan"]) /
        (product["permintaan_baku"] * product["biaya_simpan"])
    )
 
    alpha   = to * product["biaya_simpan"] / product["biaya_kekurangan"]
    z_alpha = -NormalDist().inv_cdf(alpha)
 
    fz_alpha = norm.pdf(2.22, loc=0, scale=1)
    wz_alpha = fz_alpha - 0.00001
 
    R = (
        product["permintaan_baku"] * to
        + product["permintaan_baku"] * product["lead_time"]
        + z_alpha * math.sqrt(to + product["lead_time"])
    )
 
    N = math.ceil(
        product["standar_deviasi"]
        * math.sqrt(to + product["lead_time"])
        * -(fz_alpha - z_alpha * wz_alpha)
    )
 
    T = (
        product["permintaan_baku"] * product["harga_produk"]
        + product["biaya_pesan"] / to
        + product["biaya_simpan"] * (
            R - product["permintaan_baku"] * product["lead_time"]
            + product["permintaan_baku"] * to / 2
        )
        + product["biaya_kekurangan"] / to * N
    )
 
    return T, to
 
 
def find_rss(to, product):
    """Find analytical (R, s, S) values from review interval *to*."""
    r       = product["biaya_simpan"]
    alpha   = to * r / product["biaya_kekurangan"]
    z_alpha = -NormalDist().inv_cdf(alpha)
 
    fz_alpha = norm.pdf(2.22, loc=0, scale=1)
    wz_alpha = fz_alpha - 0.00001
 
    R = (
        product["permintaan_baku"] * to
        + product["permintaan_baku"] * product["lead_time"]
        + z_alpha * math.sqrt(to + product["lead_time"])
    )
 
    N = math.ceil(
        product["standar_deviasi"]
        * math.sqrt(to + product["lead_time"])
        * -(fz_alpha - z_alpha * wz_alpha)
    )
 
    XR       = to * product["permintaan_baku"]
    XRL      = (to + product["lead_time"]) * product["permintaan_baku"]
    sigma_RL = (to + product["lead_time"]) * product["standar_deviasi"]
 
    Qp = (
        1.3
        * (XR ** 0.494)
        * ((product["biaya_pesan"] / r) ** 0.506)
        * ((1 + (sigma_RL ** 2) / (XR ** 2)) ** 0.116)
    )
    z  = math.sqrt((Qp * r) / (sigma_RL * product["biaya_kekurangan"]))
    Sp = 0.973 * XRL + sigma_RL * (0.183 / z + 1.063 - 2.192 * z)
    k  = r / (r + product["biaya_kekurangan"])
    So = XRL + k * sigma_RL
 
    R_to = to * 1000
    s    = Sp
    S    = max(Sp + Qp, So)
 
    return R_to, s, S
 
 
# ---------------------------------------------------------------------------
# Fitness / cost functions
# ---------------------------------------------------------------------------
 
def min_fitness(product, demand, init_R, init_s, init_S, init_T,
                purchases_freq, tot_lost):
    """
    Compute total inventory cost for a given (R, s, S, T) combination.
    Returns (total_cost, total_stockout_units).
    """
    half_demand = demand[:int(init_T)]
    init_R      = max(init_R, 1)
 
    if purchases_freq <= 0:
        purchases_freq = 1
 
    tot_demand         = round(sum(half_demand))
    mean_daily_demand  = np.mean(half_demand) if half_demand else 0
    std_dev_monthly    = np.std(half_demand, ddof=1) if len(half_demand) > 1 else 0
    std_dev_daily      = std_dev_monthly / np.sqrt(init_T) if init_T > 0 else 1e-9
    total_daily_demand = round(tot_demand / init_T) if init_T > 0 else 0
 
    biaya_order = product.get("biaya_order", product.get("biaya_pesan", 0))
 
    c_order        = biaya_order * (init_T / (purchases_freq * init_R))
    c_hold         = (product["biaya_simpan"] * round((init_S + init_s) / 2)
                      + round((tot_demand * init_R) / purchases_freq))
    total_stockout = round(sum(tot_lost))
 
    if std_dev_daily > 0:
        def integrand(x):
            return (x - total_daily_demand) * norm.pdf(x, mean_daily_demand, std_dev_daily)
        E_Rv, _ = quad(integrand, total_daily_demand, np.inf)
    else:
        E_Rv = 0.0
 
    c_stockout = product["biaya_kekurangan"] * E_Rv
    c_total    = c_order + c_hold + c_stockout
 
    return c_total, total_stockout
 
 
def calculate_inventory_cost(product_list, to_list):
    """Compute EOQ-based inventory cost for a list of products (used for histogram)."""
    inventory_cost_list = []
 
    for x, product in enumerate(product_list):
        A        = product["biaya_pesan"]
        D        = product["permintaan_baku"] / 2
        vr       = product["biaya_simpan"]
        B3       = product["biaya_kekurangan"]
        L        = product["lead_time"]
        Std      = product["standar_deviasi"]
        k        = round(vr / (vr + B3), 2)
        sigma_RL = (to_list[x] + L) * Std
 
        Q = math.sqrt((2 * A * D) / vr)
 
        biaya_pesan      = (A * D) / Q
        biaya_simpan     = (Q / 2) + (k * sigma_RL) * vr
        biaya_kekurangan = (B3 * sigma_RL * 0.216 * D) / Q
 
        inventory_cost_list.append(biaya_pesan + biaya_simpan + biaya_kekurangan)
 
    return inventory_cost_list
 
 
# ---------------------------------------------------------------------------
# Inventory-level simulators
# ---------------------------------------------------------------------------
 
def calculate_first_inventory_levels_rss(demand_result, purchases_result):
    """Simulate inventory using actual historical purchase data (no (R,s,S) policy)."""
    inventory_level   = []
    units_lost_list   = []
    total_demand_list = []
    restock_array     = []
    inventory         = 0
 
    for day in range(len(demand_result)):
        purchase  = purchases_result[day] if day < len(purchases_result) else 0
        demand    = demand_result[day]
        inventory += purchase
        restock_array.append(purchase)
 
        if inventory >= demand:
            inventory -= demand
            stock_out  = 0
        else:
            stock_out = demand - inventory
            inventory = 0
 
        inventory_level.append(inventory)
        total_demand_list.append(demand)
        units_lost_list.append(stock_out)
 
    purchases_freq  = sum(1 for q in restock_array if q > 0)
    purchases_total = sum(restock_array)
 
    return (inventory_level, total_demand_list, units_lost_list,
            purchases_freq, purchases_total, restock_array)
 
 
def calculate_inventory_levels_rss(demand_result, R, s, S):
    """
    Simulate inventory using the (R, s, S) periodic-review policy.
    Review every R days; if stock < s, order up to S after lead_time=1 day.
    Starts with inventory = S (fully stocked).
    """
    inventory_level   = []
    units_lost_list   = []
    total_demand_list = []
    restock_array     = []
    sales_list        = []
    purchases_list    = []
 
    review_period   = max(int(round(R)), 1)
    lead_time       = 1
    max_inventory   = S
    inventory       = S
    order_placed    = False
    counter         = 0
    purchases_freq  = 0
    purchases_total = 0
 
    for day, demand in enumerate(demand_result):
        if day % review_period == 0 and not order_placed:
            if inventory < s:
                order_placed = True
                counter      = 0
 
        if order_placed:
            counter += 1
 
        if order_placed and counter == lead_time:
            restock_qty      = max(0, max_inventory - inventory)
            inventory       += restock_qty
            restock_array.append(restock_qty)
            purchases_list.append(restock_qty)
            purchases_total += restock_qty
            purchases_freq  += 1
            order_placed     = False
            counter          = 0
        else:
            restock_array.append(0)
            purchases_list.append(0)
 
        if inventory >= demand:
            inventory -= demand
            stock_out  = 0
            sales      = demand
        else:
            stock_out  = demand - inventory
            sales      = inventory
            inventory  = 0
 
        inventory_level.append(inventory)
        total_demand_list.append(demand)
        units_lost_list.append(stock_out)
        sales_list.append(sales)
 
    return (inventory_level, purchases_list, sales_list,
            total_demand_list, units_lost_list,
            max_inventory, purchases_freq, purchases_total, restock_array)
 
 
# ---------------------------------------------------------------------------
# Genetic-algorithm operators
# ---------------------------------------------------------------------------
 
def log_scaled_mutation(individual, mutation_rate, sigma=0.1,
                         lower_bound=1, upper_bound=10000):
    """
    Log-scaled mutation on numeric genes.
    Index 5 (T) is skipped — preserved as an integer choice.
    After mutation, ensures S > s.
    """
    mutated = list(individual)
 
    for i, gene in enumerate(mutated):
        if i == 5:
            continue
        if not isinstance(gene, (int, float)):
            continue
        if random.random() < mutation_rate:
            r            = random.gauss(0, sigma)
            mutated_gene = gene * (10 ** r)
            mutated[i]   = max(min(mutated_gene, upper_bound), lower_bound)
 
    _, _, _, temp_s, temp_S, _, _, _ = mutated
    mutated[4] = max(temp_s + 1, temp_S)
 
    return tuple(mutated)
 
 
def fix_S_s(individual):
    """After crossover, guarantee S > s and T is an integer."""
    prod, demand, R, s, S, T, purchases_freq, tot_lost = individual
    S = max(s + 1, S)
    T = int(round(T))
    return (prod, demand, R, s, S, T, purchases_freq, tot_lost)
 
 
# ---------------------------------------------------------------------------
# Genetic algorithm  (core — called by PSO and directly by views)
# ---------------------------------------------------------------------------
 
def genetic_algorithm(product_data, population_size, num_generations,
                       crossover_rate, mutation_rate,
                       daily_sales, daily_purchases):
    """
    Run a genetic algorithm to minimise total inventory cost for the
    periodic (R, s, S) review policy.
 
    Returns a fixed 33-element tuple consumed by the view functions.
    """
    # ------------------------------------------------------------------ #
    # Analytical starting point
    # ------------------------------------------------------------------ #
    first_start_time = time.time()
 
    first_tot_cost, first_to         = per_review(product_data, daily_sales)
    first_R_min, first_s_min, first_S_min = find_rss(first_to, product_data)
    first_R = round(first_R_min)
    first_s = round(first_s_min)
    first_S = round(first_S_min)
    first_T = 60
 
    (first_inventory_level_list, _, first_tot_lost,
     first_purchases_freq, first_purchases_total, first_restock_data) = (
        calculate_first_inventory_levels_rss(
            daily_sales[:first_T], daily_purchases[:first_T]
        )
    )
 
    first_calc_duration = time.time() - first_start_time
 
    # ------------------------------------------------------------------ #
    # Initial population
    # ------------------------------------------------------------------ #
    population      = []
    variation       = 15
    stock_variation = 5000
 
    for _ in range(population_size):
        rand_R = random.randint(max(1, first_R - variation), first_R + variation)
        rand_s = random.randint(max(2, first_s - stock_variation), first_s + stock_variation)
        rand_S = random.randint(max(rand_s + 1, first_S), first_S + stock_variation)
        rand_T = int(random.choice([30, 45, 60]))
 
        (_, _, _, _, pop_tot_lost, _,
         pop_purchases_freq, _, _) = calculate_inventory_levels_rss(
            daily_sales[:rand_T], rand_R, rand_s, rand_S
        )
 
        population.append((product_data, daily_sales,
                            rand_R, rand_s, rand_S, rand_T,
                            pop_purchases_freq, pop_tot_lost))
 
    # ------------------------------------------------------------------ #
    # GA main loop
    # ------------------------------------------------------------------ #
    best_start_time = time.time()
    best_solution   = population[0]
 
    for generation in range(num_generations):
        fitness_scores = []
        for individual in population:
            prod_sim, demand_res, iR, is_, iS, iT, ipf, itl = individual
            cost, stockout = min_fitness(prod_sim, demand_res, iR, is_, iS, iT, ipf, itl)
            fitness_scores.append((cost, stockout))
 
        if not population:
            break
 
        best_solution = min(
            zip(population, fitness_scores),
            key=lambda x: (x[1][0], x[1][1])
        )[0]
 
        # Elitism: carry the best individual forward unchanged
        elite = best_solution
 
        # Selection (roulette wheel)
        weights = [1.0 / (1.0 + c + s) for c, s in fitness_scores]
        parents = []
        for _ in range(population_size // 2):
            p1 = random.choices(population, weights=weights)[0]
            p2 = random.choices(population, weights=weights)[0]
            parents.append((p1, p2))
 
        # Crossover
        offspring = []
        for p1, p2 in parents:
            if random.random() < crossover_rate:
                mask   = [random.randint(0, 1) for _ in range(len(p1))]
                child1 = tuple(p1[i] if mask[i] == 0 else p2[i] for i in range(len(p1)))
                child2 = tuple(p2[i] if mask[i] == 0 else p1[i] for i in range(len(p1)))
            else:
                child1, child2 = p1, p2
 
            child1 = fix_S_s(child1)
            child2 = fix_S_s(child2)
            offspring.extend([child1, child2])
 
        # Mutation
        offspring = [log_scaled_mutation(ind, mutation_rate) for ind in offspring]
 
        # Inject elite back into population (replace worst)
        offspring[-1] = elite
        population    = offspring
 
    # ------------------------------------------------------------------ #
    # Extract best solution
    # ------------------------------------------------------------------ #
    (best_product, best_demand,
     best_R, best_s, best_S, best_T,
     best_purchases_freq, best_tot_lost) = best_solution
 
    best_R = round(best_R)
    best_s = round(best_s)
    best_S = round(best_S)
    best_T = round(best_T)
 
    best_total_cost, best_to = min_fitness(
        best_product, best_demand,
        best_R, best_s, best_S, best_T,
        best_purchases_freq, best_tot_lost
    )
 
    (inventory_level_list, purchases_list, sales_list,
     tot_dmd, tot_lost, max_inventory,
     purchases_freq, purchases_total, restock_data) = calculate_inventory_levels_rss(
        best_demand[:best_T], best_R, best_s, best_S
    )
 
    best_calc_duration = time.time() - best_start_time
 
    return (
        [], [], [], [], [],
        inventory_level_list, purchases_list, sales_list,
        tot_dmd, tot_lost, max_inventory,
        purchases_freq, purchases_total, restock_data,
        best_product, best_demand,
        best_total_cost, best_to,
        best_R, best_s, best_S, best_T,
        first_R, first_s, first_S, first_T,
        first_purchases_freq, first_tot_lost, daily_sales,
        first_purchases_total,
        first_inventory_level_list, first_restock_data,
        first_calc_duration, best_calc_duration,
    )
 
 
# ===========================================================================
# PSO — Hyperparameter Optimiser
# ===========================================================================
#
# Search space (4 dimensions):
#   [0] population_size   integer  10 – 80
#   [1] num_generations   integer  10 – 80
#   [2] crossover_rate    float    0.5 – 1.0
#   [3] mutation_rate     float    0.01 – 0.5
#
# Fitness (minimise):
#   pso_fitness = best_total_cost + stockout_weight * total_stockout
#
# Strategy:
#   Run PSO with a lightweight GA budget (pop=15, gen=15) to keep wall-time
#   acceptable.  Once the best hyperparameters are found, one final full GA
#   run is executed with those params and the caller's requested budget.
# ===========================================================================
 
# Bounds for each hyperparameter dimension
PSO_BOUNDS = {
    'population_size':  (10,   80),
    'num_generations':  (10,   80),
    'crossover_rate':   (0.5,  1.0),
    'mutation_rate':    (0.01, 0.5),
}
 
# Lightweight GA budget used *inside* PSO evaluation
PSO_INNER_POP  = 15
PSO_INNER_GEN  = 15
 
# PSO algorithm settings
PSO_N_PARTICLES = 10
PSO_N_ITERS     = 20
PSO_W           = 0.7    # inertia
PSO_C1          = 1.5    # cognitive coefficient
PSO_C2          = 1.5    # social coefficient
 
# Weight applied to stockout units in the composite PSO fitness.
# Tune this to express how many rupiah one unit of stockout is worth
# relative to the cost numbers produced by min_fitness.
PSO_STOCKOUT_WEIGHT = 1.0
 
 
def _clip_particle(position):
    """Clip a PSO position vector to the declared bounds."""
    lo = [PSO_BOUNDS['population_size'][0],  PSO_BOUNDS['num_generations'][0],
          PSO_BOUNDS['crossover_rate'][0],    PSO_BOUNDS['mutation_rate'][0]]
    hi = [PSO_BOUNDS['population_size'][1],  PSO_BOUNDS['num_generations'][1],
          PSO_BOUNDS['crossover_rate'][1],    PSO_BOUNDS['mutation_rate'][1]]
    return [max(lo[i], min(hi[i], position[i])) for i in range(4)]
 
 
def _decode_particle(position):
    """
    Convert a raw PSO position vector to typed hyperparameters.
    Integer dimensions are rounded; floats are kept as-is.
    """
    pop_size        = max(2, int(round(position[0])))
    num_generations = max(1, int(round(position[1])))
    crossover_rate  = float(position[2])
    mutation_rate   = float(position[3])
    return pop_size, num_generations, crossover_rate, mutation_rate

PSO_INNER_POP = 5   # hard cap for evaluation runs
PSO_INNER_GEN = 5   # hard cap for evaluation runs

def _evaluate_particle(position, product_data, daily_sales, daily_purchases,
                        stockout_weight=PSO_STOCKOUT_WEIGHT):
    pop_size, num_generations, crossover_rate, mutation_rate = _decode_particle(position)
    """
    Run the GA with the hyperparameters encoded in *position* and return
    the composite fitness score (lower is better).

    Uses a fixed lightweight inner budget so each PSO evaluation is cheap.
    """
    
    pop_size        = min(pop_size, PSO_INNER_POP)
    num_generations = min(num_generations, PSO_INNER_GEN)

    try:
        result          = genetic_algorithm(
            product_data, pop_size, num_generations,
            crossover_rate, mutation_rate,
            daily_sales, daily_purchases,
        )
        best_total_cost = result[16]
        tot_lost        = result[9]
        total_stockout  = round(sum(tot_lost))
        return best_total_cost + stockout_weight * total_stockout
    except Exception:
        # If a particle configuration produces a degenerate GA run,
        # return a very large penalty so PSO steers away from it.
        return float('inf')

def pso_optimize_hyperparameters(product_data, daily_sales, daily_purchases,
                                  n_particles=PSO_N_PARTICLES,
                                  n_iters=PSO_N_ITERS,
                                  w=PSO_W, c1=PSO_C1, c2=PSO_C2,
                                  stockout_weight=PSO_STOCKOUT_WEIGHT):
    """
    Run Particle Swarm Optimisation to find the best GA hyperparameters
    for the given product and demand data.
 
    Returns
    -------
    best_params : dict
        Keys: population_size, num_generations, crossover_rate, mutation_rate
    best_score : float
        The composite inventory cost achieved by the best hyperparameter set
    history : list of float
        Global best score at each PSO iteration (for plotting convergence)
    """
    lo = [PSO_BOUNDS['population_size'][0],  PSO_BOUNDS['num_generations'][0],
          PSO_BOUNDS['crossover_rate'][0],    PSO_BOUNDS['mutation_rate'][0]]
    hi = [PSO_BOUNDS['population_size'][1],  PSO_BOUNDS['num_generations'][1],
          PSO_BOUNDS['crossover_rate'][1],    PSO_BOUNDS['mutation_rate'][1]]
 
    dim = 4  # number of hyperparameter dimensions
 
    # ---- Initialise particles ----------------------------------------- #
    positions  = []
    velocities = []
 
    for _ in range(n_particles):
        pos = [random.uniform(lo[d], hi[d]) for d in range(dim)]
        vel = [random.uniform(-(hi[d] - lo[d]) * 0.1,
                               (hi[d] - lo[d]) * 0.1) for d in range(dim)]
        positions.append(pos)
        velocities.append(vel)
 
    # Personal bests
    personal_best_pos   = [p[:] for p in positions]
    personal_best_score = [
        _evaluate_particle(p, product_data, daily_sales, daily_purchases, stockout_weight)
        for p in positions
    ]
 
    # Global best
    global_best_idx   = int(np.argmin(personal_best_score))
    global_best_pos   = personal_best_pos[global_best_idx][:]
    global_best_score = personal_best_score[global_best_idx]
 
    history = [global_best_score]
 
    # ---- PSO main loop ------------------------------------------------- #
    for iteration in range(n_iters):
        for i in range(n_particles):
            r1 = [random.random() for _ in range(dim)]
            r2 = [random.random() for _ in range(dim)]
 
            # Velocity update
            velocities[i] = [
                w * velocities[i][d]
                + c1 * r1[d] * (personal_best_pos[i][d] - positions[i][d])
                + c2 * r2[d] * (global_best_pos[d]       - positions[i][d])
                for d in range(dim)
            ]
 
            # Position update and clipping to bounds
            positions[i] = _clip_particle([
                positions[i][d] + velocities[i][d] for d in range(dim)
            ])
 
            # Evaluate
            score = _evaluate_particle(
                positions[i], product_data, daily_sales, daily_purchases, stockout_weight
            )
 
            # Update personal best
            if score < personal_best_score[i]:
                personal_best_score[i] = score
                personal_best_pos[i]   = positions[i][:]
 
            # Update global best
            if score < global_best_score:
                global_best_score = score
                global_best_pos   = positions[i][:]
 
        history.append(global_best_score)
 
    # ---- Decode and return best hyperparameters ----------------------- #
    pop_size, num_gen, cr, mr = _decode_particle(global_best_pos)
 
    best_params = {
        'population_size':  pop_size,
        'num_generations':  num_gen,
        'crossover_rate':   round(cr, 4),
        'mutation_rate':    round(mr, 4),
    }
 
    return best_params, global_best_score, history
 
 
# ---------------------------------------------------------------------------
# Convenience wrapper used by both views
# ---------------------------------------------------------------------------
 
def run_with_pso(product_data, daily_sales, daily_purchases,
                 user_pop_size, user_num_gen, user_cr, user_mr,
                 use_pso=True,
                 pso_n_particles=PSO_N_PARTICLES,
                 pso_n_iters=PSO_N_ITERS,
                 stockout_weight=PSO_STOCKOUT_WEIGHT):
    """
    If use_pso=True:
        1. Run PSO to find optimal hyperparameters (cheap inner budget).
        2. Run one final GA with those hyperparameters at the user's budget
           (population_size and num_generations from the form are used as
           the *ceiling* for the final GA run if they are larger than what
           PSO found; otherwise PSO's values win).
        3. Return GA result tuple + pso metadata dict.
 
    If use_pso=False:
        Just run the GA with the user-supplied hyperparameters and return
        dummy pso metadata.
    """
    pso_meta = {
        'used':             use_pso,
        'best_params':      None,
        'best_score':       None,
        'history':          [],
        'pso_duration':     0.0,
    }
 
    if use_pso:
        pso_start = time.time()
 
        best_params, best_score, history = pso_optimize_hyperparameters(
            product_data, daily_sales, daily_purchases,
            n_particles    = pso_n_particles,
            n_iters        = pso_n_iters,
            stockout_weight= stockout_weight,
        )
 
        pso_meta['best_params']  = best_params
        pso_meta['best_score']   = best_score
        pso_meta['history']      = history
        pso_meta['pso_duration'] = time.time() - pso_start
 
        # Use PSO-found hyperparameters for the final run.
        # Take the larger budget between user input and PSO recommendation
        # so the user's manual settings are never made worse.
        final_pop  = max(best_params['population_size'],  user_pop_size)
        final_gen  = max(best_params['num_generations'],  user_num_gen)
        final_cr   = best_params['crossover_rate']
        final_mr   = best_params['mutation_rate']
    else:
        final_pop = user_pop_size
        final_gen = user_num_gen
        final_cr  = user_cr
        final_mr  = user_mr
 
    ga_result = genetic_algorithm(
        product_data, final_pop, final_gen, final_cr, final_mr,
        daily_sales, daily_purchases,
    )
 
    return ga_result, pso_meta
 
 
# ---------------------------------------------------------------------------
# Plot helpers
# ---------------------------------------------------------------------------
 
def _plot_pso_convergence(history):
    """
    Return a base64-encoded PNG of the PSO convergence curve.
    history is a list of global-best scores per iteration.
    """
    fig, ax = plt.subplots(figsize=(8, 4))
    ax.plot(history, linewidth=1.8, color="#097969", marker='o', markersize=3)
    ax.set_xlabel('PSO Iteration', fontsize=13)
    ax.set_ylabel('Best Composite Cost', fontsize=13)
    ax.set_title('PSO Convergence — Hyperparameter Optimisation', fontsize=14)
    ax.yaxis.set_major_formatter(FuncFormatter(lambda x, _: f'{int(x):,}'))
    ax.grid(True, linestyle='--', alpha=0.4)
    plt.tight_layout()
 
    buf = io.BytesIO()
    fig.savefig(buf, format='png')
    buf.seek(0)
    encoded = base64.b64encode(buf.read()).decode('utf-8')
    buf.close()
    plt.close()
    return encoded
 
 
def _plot_inventory_level(inventory_level_list, upper_line, x_limit):
    fig, ax = plt.subplots(figsize=(18, 6))
    ax.plot(inventory_level_list, linewidth=1.5)
    ax.axhline(upper_line, linewidth=2, color="grey", linestyle=":")
    ax.axhline(0,          linewidth=2, color="grey", linestyle=":")
    ax.set_xlim(0, x_limit)
    ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
    ax.set_xlabel('Day',                   fontsize=18)
    buf = io.BytesIO()
    fig.savefig(buf)
    buf.seek(0)
    encoded = base64.b64encode(buf.read()).decode()
    buf.close()
    plt.close()
    return encoded
 
 
def _plot_stockout_hist(values, label='Stockout'):
    fig, ax = plt.subplots(figsize=(6, 4))
    if values:
        sns.histplot(values, kde=False, color="#097969", ax=ax)
        mean_val = np.mean(values)
        ax.set_title(f'{label} : Mean {mean_val:.3f}')
        ax.axvline(x=mean_val, color='k', alpha=0.5, ls='--')
    plt.tight_layout()
    buf = io.BytesIO()
    fig.savefig(buf)
    buf.seek(0)
    encoded = base64.b64encode(buf.read()).decode()
    buf.close()
    plt.close()
    return encoded
 
 
# ---------------------------------------------------------------------------
# Views
# ---------------------------------------------------------------------------
 
@login_required
def periodic_view(request):
    if request.method == 'POST':
        array = []
        data  = []
 
        try:
            outlet_id = request.user.employee.outlet_id
            items     = Item.objects.filter(type="JADI")
 
            for item in items:
                if request.user.employee.role == 'superadmin':
                    sales = Sales.objects.filter(item_id=item.id)
                else:
                    sales = Sales.objects.filter(outlet_id=outlet_id, item_id=item.id)
 
                sales_list      = [sale.amount for sale in sales]
                total_sales     = sum(sales_list)
                standar_deviasi = (np.std(sales_list) if len(sales_list) > 1
                                   else (sales_list[0] if sales_list else 1))
 
                array.append({
                    'nama_barang':      item.name,
                    'biaya_pesan':      item.biaya_pesan,
                    'biaya_order':      item.biaya_pesan,
                    'permintaan_baku':  total_sales,
                    'biaya_simpan':     2000,
                    'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                    'harga_produk':     item.price,
                    'lead_time':        item.lead_time / 100,
                    'standar_deviasi':  standar_deviasi,
                })
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")
            return redirect(request.META.get('HTTP_REFERER', '/'))
 
        # Read form inputs
        pop_size        = _parse_post_int  (request.POST, 'population_size', 30)
        num_generations = _parse_post_int  (request.POST, 'num_generations', 50)
        crossover_rate  = _parse_post_float(request.POST, 'crossover_rate',  0.8)
        mutation_rate   = _parse_post_float(request.POST, 'mutation_rate',   0.1)
 
        # PSO toggle & settings from form (with safe defaults)
        use_pso         = request.POST.get('use_pso', 'false').lower() == 'true'
        pso_n_particles = _parse_post_int  (request.POST, 'pso_particles',    PSO_N_PARTICLES)
        pso_n_iters     = _parse_post_int  (request.POST, 'pso_iters',        PSO_N_ITERS)
        stockout_weight = _parse_post_float(request.POST, 'stockout_weight',  PSO_STOCKOUT_WEIGHT)
 
        for x in array:
            product = dict(x)
 
            # Build daily time-series from DB
            item_obj       = Item.objects.get(name=product['nama_barang'])
            sales_data     = (Sales.objects.filter(item_id=item_obj.id)
                              .values('created_at').annotate(total_sales=Sum('amount')))
            purchases_data = (Purchase.objects.filter(item_id=item_obj.id)
                              .values('created_at').annotate(total_purchases=Sum('amount')))
 
            sales_dict     = {s['created_at'].date(): s['total_sales']     for s in sales_data}
            purchases_dict = {p['created_at'].date(): p['total_purchases'] for p in purchases_data}
 
            start_date   = min(sales_dict.keys(), default=datetime.today().date())
            end_date     = start_date + timedelta(days=59)
            daily_sales  = []
            daily_purchases = []
            cur = start_date
            while cur <= end_date:
                daily_sales.append(sales_dict.get(cur, 0))
                daily_purchases.append(purchases_dict.get(cur, 0))
                cur += timedelta(days=1)
 
            # ---- Run GA (with optional PSO hyperparameter search) ---- #
            ga_result, pso_meta = run_with_pso(
                product, daily_sales, daily_purchases,
                pop_size, num_generations, crossover_rate, mutation_rate,
                use_pso         = use_pso,
                pso_n_particles = pso_n_particles,
                pso_n_iters     = pso_n_iters,
                stockout_weight = stockout_weight,
            )
 
            (_, _, _, _, _,
             inventory_level_list, purchases_list, sales_list,
             tot_dmd, tot_lost, max_inventory,
             purchases_freq, purchases_total, restock_data,
             best_product, best_demand,
             best_total_cost, best_to,
             best_R, best_s, best_S, best_T,
             first_R, first_s, first_S, first_T,
             first_purchases_freq, first_tot_lost, first_demand,
             first_purchases_total,
             first_inventory_level_list, first_restock_data,
             first_calc_duration, best_calc_duration) = ga_result
 
            # ---- Plots ---------------------------------------------- #
            demand_result_filtered = [i for i in best_demand if i != 0]
            plt.figure(figsize=(6, 4))
            plt.hist(demand_result_filtered, color="#097969")
            plt.xlabel('Demand')
            plt.ylabel('Frequency')
            plt.tight_layout()
            flike = io.BytesIO()
            plt.savefig(flike)
            demand_plot = base64.b64encode(flike.getvalue()).decode()
            plt.close()
 
            inventory_cost_list = [best_total_cost]
            plt.figure(figsize=(6, 4))
            plt.hist(inventory_cost_list, color="#097969")
            plt.xlabel('Inventory Cost')
            plt.ylabel('Frequency')
            plt.gca().xaxis.set_major_formatter(FuncFormatter(lambda x, _: f'{int(x):,}'))
            plt.xticks(rotation=45)
            plt.tight_layout()
            flike = io.BytesIO()
            plt.savefig(flike)
            biaya_inventory_plot = base64.b64encode(flike.getvalue()).decode()
            plt.close()
 
            simulation_lost_plot = _plot_stockout_hist(list(tot_lost), 'Lost Order')
            inventory_level_plot = _plot_inventory_level(inventory_level_list, best_S, best_T)
 
            # PSO convergence plot (only if PSO was used)
            pso_convergence_plot = (
                _plot_pso_convergence(pso_meta['history']) if use_pso else None
            )
 
            data.append({
                'nama_barang':             product["nama_barang"],
                'R':                       round(best_R),
                's':                       round(best_s),
                'S':                       round(best_S),
                'order_lost':              round(sum(tot_lost) / 2),
                'biaya_inventory_min':     round(min(inventory_cost_list)),
                'biaya_inventory_mean':    round(np.mean(inventory_cost_list)),
                'biaya_inventory_std':     round(np.std(inventory_cost_list)),
                'demand_plot':             demand_plot,
                'biaya_inventory_plot':    biaya_inventory_plot,
                'inventory_level_plot':    inventory_level_plot,
                'simulation_lost_plot':    simulation_lost_plot,
                'pso_convergence_plot':    pso_convergence_plot,
                # PSO metadata (available in template)
                'pso_used':                pso_meta['used'],
                'pso_duration':            round(pso_meta['pso_duration'], 2),
                'pso_best_score':          round(pso_meta['best_score'], 2) if pso_meta['best_score'] else None,
                'pso_best_params':         pso_meta['best_params'],
                'mc_result':               best_product,
                'demand_result':           best_demand,
                'biaya_penyimpanan':       0,
                'total_biaya_penyimpanan': round(best_to, 4),
            })
 
        return render(request, 'periodic/calculation.html', {'data': data})
 
    return render(request, 'periodic/index.html', {'data': ''})
 
 
# ---------------------------------------------------------------------------
 
@login_required
def inventory_collab_view(request):
    if request.method == 'POST':
        pop_size        = _parse_post_int  (request.POST, 'population_size', 30)
        num_generations = _parse_post_int  (request.POST, 'num_generations', 50)
        crossover_rate  = _parse_post_float(request.POST, 'crossover_rate',  0.8)
        mutation_rate   = _parse_post_float(request.POST, 'mutation_rate',   0.1)
 
        use_pso         = request.POST.get('use_pso', 'false').lower() == 'true'
        pso_n_particles = _parse_post_int  (request.POST, 'pso_particles',   PSO_N_PARTICLES)
        pso_n_iters     = _parse_post_int  (request.POST, 'pso_iters',       PSO_N_ITERS)
        stockout_weight = _parse_post_float(request.POST, 'stockout_weight', PSO_STOCKOUT_WEIGHT)
 
        outlets = Outlet.objects.all()
        items   = Item.objects.filter(type="JADI")
 
        # ---------------------------------------------------------------- #
        # Superadmin branch
        # ---------------------------------------------------------------- #
        if request.user.employee.role == 'superadmin':
            total_data_dict               = {}
            first_outlet_inventory_levels = {}
            outlet_inventory_levels       = {}
            data_all                      = []
 
            # ----------------------------------------------------------------
            # PSO PHASE — run ONCE per item, not once per item per outlet.
            # We use outlet 3 (main/vendor) data as the representative signal
            # for tuning. If outlet 3 has no data for an item, we fall back to
            # the user-supplied hyperparameters unchanged.
            # ----------------------------------------------------------------
            global_pso_params = None
 
            if use_pso:
                PSO_OUTLET_ID = 3
                products_data = []   # list of (product_dict, daily_sales, daily_purchases)

                for item in items:
                    try:
                        pso_sales_qs = (Sales.objects.filter(outlet_id=PSO_OUTLET_ID, item_id=item.id)
                                        .values('created_at')
                                        .annotate(total_sales=Sum('amount')))
                        pso_purch_qs = (Purchase.objects.filter(outlet_id=PSO_OUTLET_ID, item_id=item.id)
                                        .values('created_at')
                                        .annotate(total_purchases=Sum('amount')))

                        pso_sales_dict = {r['created_at'].date(): r['total_sales']     for r in pso_sales_qs}
                        pso_purch_dict = {r['created_at'].date(): r['total_purchases'] for r in pso_purch_qs}

                        if not pso_sales_dict:
                            continue

                        pso_start_date  = min(pso_sales_dict.keys())
                        pso_end_date    = pso_start_date + timedelta(days=59)
                        pso_daily_sales = []
                        pso_daily_purch = []
                        cur = pso_start_date
                        while cur <= pso_end_date:
                            pso_daily_sales.append(pso_sales_dict.get(cur, 0))
                            pso_daily_purch.append(pso_purch_dict.get(cur, 0))
                            cur += timedelta(days=1)

                        pso_total_sales = sum(pso_daily_sales)
                        pso_std         = np.std(pso_daily_sales) if len(pso_daily_sales) > 1 else 1

                        pso_product = {
                            'nama_barang':      item.name,
                            'biaya_pesan':      item.biaya_pesan,
                            'biaya_order':      20000,
                            'permintaan_baku':  pso_total_sales if pso_total_sales > 0 else 1,
                            'biaya_simpan':     5000,
                            'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                            'harga_produk':     item.price,
                            'lead_time':        item.lead_time / 100,
                            'standar_deviasi':  pso_std,
                        }

                        products_data.append((pso_product, pso_daily_sales, pso_daily_purch))

                    except Exception:
                        continue

                if products_data:
                    global_pso_params, _, _ = pso_optimize_hyperparameters_global(
                        products_data,
                        n_particles     = pso_n_particles,
                        n_iters         = pso_n_iters,
                        stockout_weight = stockout_weight,
                    )
 
            # ----------------------------------------------------------------
            # GA PHASE — loop outlets × items, use cached PSO params
            # ----------------------------------------------------------------
            for outlet in outlets:
                biaya_simpan = {3: 5000, 5: 1800, 6: 2000, 7: 1500}.get(outlet.id, 2000)
                biaya_order  = 20000 if outlet.id == 3 else 10000
 
                first_combined_inventory_level = [0] * 60
                combined_inventory_level       = [0] * 60
                combined_purchases_list        = [0] * 60
                combined_sales_list            = [0] * 60
                first_single_inventory_level   = [0] * 60
                single_inventory_level         = [0] * 60
                single_purchases_list          = [0] * 60
                single_sales_list              = [0] * 60
                first_multiple_inventory_data  = []
                multiple_inventory_data        = []
 
                data = []
 
                for item_index, item in enumerate(items):
                    sales       = Sales.objects.filter(outlet_id=outlet.id, item_id=item.id)
                    outlet_item = OutletItem.objects.filter(outlet=outlet.id, item=item.id).first()
 
                    sales_list_raw  = [sale.amount for sale in sales]
                    total_sales     = sum(sales_list_raw)
                    standar_deviasi = (np.std(sales_list_raw) if len(sales_list_raw) > 1
                                       else (sales_list_raw[0] if sales_list_raw else 1))
 
                    sales_data     = (Sales.objects.filter(outlet_id=outlet.id, item_id=item.id)
                                      .values('created_at').annotate(total_sales=Sum('amount')))
                    purchases_data = (Purchase.objects.filter(outlet_id=outlet.id, item_id=item.id)
                                      .values('created_at').annotate(total_purchases=Sum('amount')))
 
                    sales_dict     = {s['created_at'].date(): s['total_sales']     for s in sales_data}
                    purchases_dict = {p['created_at'].date(): p['total_purchases'] for p in purchases_data}
 
                    start_date = min(sales_dict.keys(), default=datetime.today().date())
                    end_date   = start_date + timedelta(days=59)
 
                    daily_sales     = []
                    daily_purchases = []
                    cur = start_date
                    while cur <= end_date:
                        daily_sales.append(sales_dict.get(cur, 0))
                        daily_purchases.append(purchases_dict.get(cur, 0))
                        cur += timedelta(days=1)
 
                    product = {
                        'nama_barang':      item.name,
                        'biaya_pesan':      item.biaya_pesan,
                        'biaya_order':      biaya_order,
                        'permintaan_baku':  total_sales,
                        'biaya_simpan':     biaya_simpan,
                        'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                        'harga_produk':     item.price,
                        'lead_time':        outlet_item.lead_time / 100,
                        'standar_deviasi':  standar_deviasi,
                    }
 
                    # Resolve final GA hyperparameters from PSO cache
                    if global_pso_params:
                        final_pop = max(global_pso_params['population_size'], pop_size)
                        final_gen = max(global_pso_params['num_generations'],  num_generations)
                        final_cr  = global_pso_params['crossover_rate']
                        final_mr  = global_pso_params['mutation_rate']
                        pso_meta  = {
                            'used':         True,
                            'best_params':  global_pso_params,
                            'best_score':   None,
                            'history':      [],
                            'pso_duration': 0.0,
                        }
                    else:
                        final_pop = pop_size
                        final_gen = num_generations
                        final_cr  = crossover_rate
                        final_mr  = mutation_rate
                        pso_meta  = {
                            'used':         False,
                            'best_params':  None,
                            'best_score':   None,
                            'history':      [],
                            'pso_duration': 0.0,
                        }
 
                    # Run GA with resolved hyperparameters (no PSO inside)
                    ga_result = genetic_algorithm(
                        product, final_pop, final_gen, final_cr, final_mr,
                        daily_sales, daily_purchases,
                    )
 
                    (_, _, _, _, _,
                     inventory_level_list, purchases_list, sales_list,
                     total_demand, total_lost, max_inventory,
                     purchases_freq, purchases_total, restock_data,
                     best_product, best_demand,
                     best_total_cost, best_to,
                     best_R, best_s, best_S, best_T,
                     first_R, first_s, first_S, first_T,
                     first_purchases_freq, first_total_lost, first_demand,
                     first_purchases_total,
                     first_inventory_level_list, first_restock_data,
                     first_calc_duration, best_calc_duration) = ga_result
 
                    # ---- FIRST (analytical baseline) cost ------------ #
                    temp_first_start   = time.time()
                    first_half_demand  = first_demand[:first_T]
                    first_total_demand = round(sum(first_half_demand))
                    first_mean_daily   = np.mean(first_half_demand) if first_half_demand else 0
                    first_std_monthly  = np.std(first_half_demand, ddof=1) if len(first_half_demand) > 1 else 0
                    first_std_daily    = first_std_monthly / np.sqrt(first_T) if first_T > 0 else 1e-9
                    first_total_daily_dmd = round(first_total_demand / first_T) if first_T > 0 else 0
 
                    first_restock_nz     = [x for x in first_restock_data if x != 0]
                    first_restock_z      = [x for x in first_restock_data if x == 0]
                    first_restock_result = first_restock_nz + first_restock_z
 
                    first_stock_history = []
                    first_stock = 0
                    for i in range(first_T):
                        first_stock += round(first_restock_result[i])
                        first_stock -= round(first_restock_data[i])
                        first_stock_history.append(first_stock)
 
                    for day in range(min(first_T, len(first_inventory_level_list))):
                        first_combined_inventory_level[day] += first_inventory_level_list[day]
 
                    if outlet.id == 3:
                        first_multiple_inventory_data.append({
                            'inventory':  first_inventory_level_list[:first_T],
                            'item_index': item_index,
                            'item_name':  item.name,
                            'outlet_id':  outlet.id,
                        })
 
                    if item_index == 1:
                        for day in range(min(first_T, len(first_inventory_level_list))):
                            first_single_inventory_level[day] += first_inventory_level_list[day]
 
                    fp_freq         = max(first_purchases_freq, 1)
                    first_c_order   = biaya_order * (first_T / (fp_freq * first_R))
                    first_c_hold    = (biaya_simpan * ((first_S + first_s) / 2)
                                       + (first_total_demand * first_R) / fp_freq)
                    first_total_so  = round(sum(first_total_lost))
 
                    if first_std_daily > 0:
                        def integrand_first(x):
                            return (x - first_total_daily_dmd) * norm.pdf(x, first_mean_daily, first_std_daily)
                        E_Rv_first, _ = quad(integrand_first, first_total_daily_dmd, np.inf)
                    else:
                        E_Rv_first = 0.0
 
                    first_c_stockout  = product["biaya_kekurangan"] * E_Rv_first
                    first_c_total     = first_c_order + first_c_hold + first_c_stockout
                    first_calc_duration += time.time() - temp_first_start
 
                    # ---- BEST (GA-optimised) cost -------------------- #
                    temp_best_start = time.time()
                    half_demand     = best_demand[:best_T]
                    tot_demand_best = round(sum(half_demand))
                    mean_daily      = np.mean(half_demand) if half_demand else 0
                    std_monthly     = np.std(half_demand, ddof=1) if len(half_demand) > 1 else 0
                    std_daily       = std_monthly / np.sqrt(best_T) if best_T > 0 else 1e-9
                    total_daily_dmd = round(tot_demand_best / best_T) if best_T > 0 else 0
 
                    restock_nz     = [x for x in restock_data if x != 0]
                    restock_z      = [x for x in restock_data if x == 0]
                    restock_result = restock_nz + restock_z
 
                    stock_history = []
                    stock = 0
                    for i in range(best_T):
                        stock += round(restock_result[i])
                        stock -= round(restock_data[i])
                        stock_history.append(stock)
 
                    for day in range(min(best_T, len(inventory_level_list))):
                        combined_inventory_level[day] += inventory_level_list[day]
                        combined_purchases_list[day]  += purchases_list[day]
                        combined_sales_list[day]      += sales_list[day]
 
                    if outlet.id == 3:
                        multiple_inventory_data.append({
                            'inventory':  inventory_level_list[:best_T],
                            'purchases':  purchases_list[:best_T],
                            'sales':      sales_list[:best_T],
                            'item_index': item_index,
                            'item_name':  item.name,
                            'outlet_id':  outlet.id,
                        })
 
                    if item_index == 1:
                        for day in range(min(best_T, len(inventory_level_list))):
                            single_inventory_level[day]  += inventory_level_list[day]
                            single_purchases_list[day]   += purchases_list[day]
                            single_sales_list[day]       += sales_list[day]
 
                    mod_pf   = max(purchases_freq, 1)
                    c_order  = biaya_order * (best_T / (mod_pf * best_R))
                    c_hold   = (biaya_simpan * round((best_S + best_s) / 2)
                                + round((tot_demand_best * best_R) / mod_pf))
                    total_so = round(sum(total_lost))
 
                    if std_daily > 0:
                        def integrand_best(x):
                            return (x - total_daily_dmd) * norm.pdf(x, mean_daily, std_daily)
                        E_Rv_best, _ = quad(integrand_best, total_daily_dmd, np.inf)
                    else:
                        E_Rv_best = 0.0
 
                    c_stockout = product["biaya_kekurangan"] * E_Rv_best
                    c_total    = c_order + c_hold + c_stockout
                    best_calc_duration += time.time() - temp_best_start
 
                    item_data = {
                        'outlet_id':             outlet.id,
                        'first_c_order':         round(first_c_order),
                        'first_c_hold':          round(first_c_hold),
                        'first_c_stockout':      round(first_c_stockout),
                        'first_c_total':         round(first_c_total),
                        'first_purchases_freq':  round(fp_freq),
                        'first_purchases_total': round(first_purchases_total),
                        'first_stockout_total':  first_total_so,
                        'first_stockout_mean':   [first_total_so],
                        'first_restock_data':    [a - b for a, b in zip(half_demand, first_restock_data[:len(half_demand)])],
                        'first_stock_history':   first_stock_history,
                        'first_timespan':        first_T,
                        'first_calc_duration':   first_calc_duration,
                        'outlet_first_R':        first_R,
                        'outlet_first_s':        first_s,
                        'outlet_first_S':        first_S,
                        'c_order':               round(c_order),
                        'c_hold':                round(c_hold),
                        'c_stockout':            round(c_stockout),
                        'c_total':               round(c_total),
                        'purchases_freq':        1 if outlet.id == 3 else round(purchases_freq),
                        'purchases_total':       round(purchases_total),
                        'stockout_total':        total_so,
                        'stockout_mean':         [total_so],
                        'restock_data':          [a - b for a, b in zip(half_demand, restock_data[:len(half_demand)])],
                        'stock_history':         stock_history,
                        'timespan':              best_T,
                        'best_calc_duration':    best_calc_duration,
                        'outlet_best_R':         best_R,
                        'outlet_best_s':         best_s,
                        'outlet_best_S':         best_S,
                        'pso_used':              pso_meta['used'],
                        'pso_best_params':       pso_meta['best_params'],
                        'pso_duration':          round(pso_meta['pso_duration'], 2),
                    }
 
                    # Aggregate into total_data_dict
                    name = product["nama_barang"]
                    if name in total_data_dict:
                        td = total_data_dict[name]
                        for fkey in ('first_c_order', 'first_c_hold', 'first_c_stockout',
                                     'first_c_total', 'first_purchases_freq',
                                     'first_purchases_total', 'first_stockout_total',
                                     'first_calc_duration', 'outlet_first_R',
                                     'outlet_first_s', 'outlet_first_S',
                                     'c_order', 'c_hold', 'c_stockout', 'c_total',
                                     'purchases_total', 'stockout_total',
                                     'best_calc_duration', 'outlet_best_R',
                                     'outlet_best_s', 'outlet_best_S'):
                            td[fkey] += item_data[fkey]
                        td['purchases_freq']      += 1 if outlet.id == 3 else item_data['purchases_freq']
                        td['first_stockout_mean'] += item_data['first_stockout_mean']
                        td['stockout_mean']        += item_data['stockout_mean']
                        for lkey in ('first_restock_data', 'first_stock_history',
                                     'restock_data', 'stock_history'):
                            td[lkey] = [a + b for a, b in zip(td[lkey], item_data[lkey])]
                        td['first_timespan'] = min(td['first_timespan'], item_data['first_timespan'])
                        td['timespan']       = min(td['timespan'],       item_data['timespan'])
                    else:
                        total_data_dict[name] = {
                            'nama_barang': name,
                            **{k: item_data[k] for k in item_data if k != 'outlet_id'},
                        }
                        total_data_dict[name]['purchases_freq'] = (
                            1 if outlet.id == 3 else item_data['purchases_freq']
                        )
 
                    data.append({
                        'nama_barang':           product["nama_barang"],
                        'first_c_order':         round(first_c_order),
                        'first_c_hold':          round(first_c_hold),
                        'first_c_stockout':      round(first_c_stockout),
                        'first_c_total':         round(first_c_total),
                        'first_purchases_freq':  round(fp_freq),
                        'first_purchases_total': round(first_purchases_total),
                        'first_stockout_total':  first_total_so,
                        'first_timespan':        first_T,
                        'first_calc_duration':   first_calc_duration,
                        'outlet_first_R':        first_R,
                        'outlet_first_s':        first_s,
                        'outlet_first_S':        first_S,
                        'c_order':               round(c_order),
                        'c_hold':                round(c_hold),
                        'c_stockout':            round(c_stockout),
                        'c_total':               round(c_total),
                        'purchases_freq':        1 if outlet.id == 3 else round(purchases_freq),
                        'purchases_total':       round(purchases_total),
                        'stockout_total':        total_so,
                        'timespan':              best_T,
                        'best_calc_duration':    best_calc_duration,
                        'outlet_best_R':         best_R,
                        'outlet_best_s':         best_s,
                        'outlet_best_S':         best_S,
                        'pso_used':              pso_meta['used'],
                        'pso_best_params':       pso_meta['best_params'],
                        'pso_duration':          round(pso_meta['pso_duration'], 2),
                    })
 
                data_all.append({
                    'outlet':                         outlet,
                    'data':                           data,
                    'first_combined_inventory_level': first_combined_inventory_level,
                    'combined_inventory_level':       combined_inventory_level,
                    'combined_purchases_list':        combined_purchases_list,
                    'combined_sales_list':            combined_sales_list,
                    'first_single_inventory_level':   first_single_inventory_level,
                    'single_inventory_level':         single_inventory_level,
                    'single_purchases_list':          single_purchases_list,
                    'single_sales_list':              single_sales_list,
                    'first_multiple_inventory_data':  first_multiple_inventory_data,
                    'multiple_inventory_data':        multiple_inventory_data,
                    'first_total_order':              sum(i['first_c_order']         for i in data),
                    'first_total_hold':               sum(i['first_c_hold']          for i in data),
                    'first_total_stockout':           sum(i['first_c_stockout']      for i in data),
                    'first_total_all':                sum(i['first_c_total']         for i in data),
                    'first_total_purchases_freq':     sum(i['first_purchases_freq']  for i in data),
                    'first_total_purchases_total':    sum(i['first_purchases_total'] for i in data),
                    'first_total_stockout_total':     sum(i['first_stockout_total']  for i in data),
                    'first_total_calc_duration':      sum(i['first_calc_duration']   for i in data),
                    'total_order':                    sum(i['c_order']           for i in data),
                    'total_hold':                     sum(i['c_hold']            for i in data),
                    'total_stockout':                 sum(i['c_stockout']        for i in data),
                    'total_all':                      sum(i['c_total']           for i in data),
                    'total_purchases_freq':           sum(i['purchases_freq']    for i in data),
                    'total_purchases_total':          sum(i['purchases_total']   for i in data),
                    'total_stockout_total':           sum(i['stockout_total']    for i in data),
                    'total_calc_duration':            sum(i['best_calc_duration'] for i in data),
                })
 
            total_data = list(total_data_dict.values())
 
            # ---- Plots for aggregated vendor-level totals ------------ #
            for dt in total_data:
                span_f = dt['first_timespan']
                span_b = dt['timespan']
 
                fig, ax = plt.subplots(figsize=(18, 6))
                ax.plot(dt['first_stock_history'][:span_f], linewidth=1.5)
                ax.set_xlim(0, span_f)
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)
                buf = io.BytesIO()
                fig.savefig(buf)
                buf.seek(0)
                dt['first_inventory_level_plot'] = base64.b64encode(buf.read()).decode()
                buf.close()
                plt.close()
 
                dt['first_lost_order_plot'] = _plot_stockout_hist(
                    dt['first_stockout_mean'], 'Total Stockout'
                )
 
                fig, ax = plt.subplots(figsize=(18, 6))
                ax.plot(dt['stock_history'][:span_b], linewidth=1.5)
                ax.set_xlim(0, span_b)
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)
                buf = io.BytesIO()
                fig.savefig(buf)
                buf.seek(0)
                dt['inventory_level_plot'] = base64.b64encode(buf.read()).decode()
                buf.close()
                plt.close()
 
                dt['lost_order_plot'] = _plot_stockout_hist(
                    dt['stockout_mean'], 'Total Stockout'
                )
 
            # ---- Adjust outlet 3 inventory & generate outlet plots -- #
            for dt in data_all:
                if dt['outlet'].id == 3:
                    for inv_key, p_key, s_key in [
                        ('combined_inventory_level', 'combined_purchases_list', 'combined_sales_list'),
                        ('single_inventory_level',   'single_purchases_list',   'single_sales_list'),
                    ]:
                        purch_all = [d[p_key] for d in data_all if d['outlet'].id != 3]
                        sales_all = [d[s_key] for d in data_all if d['outlet'].id != 3]
                        if purch_all:
                            total_p = [sum(x) for x in zip(*purch_all)]
                            total_s = [sum(x) for x in zip(*sales_all)]
                            new_inv = []
                            cur     = sum(total_p) - total_s[0]
                            new_inv.append(cur)
                            for sale in total_s[1:]:
                                cur -= sale
                                new_inv.append(cur)
                            dt[inv_key] = new_inv
 
                # Use the last known first_T / best_T for span — safe because
                # these are outlet-level loops and the variables are still in scope
                for il_key, plot_key, span in [
                    ('first_combined_inventory_level', 'first_restock_plot',        first_T),
                    ('first_single_inventory_level',   'first_single_restock_plot', first_T),
                    ('combined_inventory_level',       'restock_plot',              best_T),
                    ('single_inventory_level',         'single_restock_plot',       best_T),
                ]:
                    fig, ax = plt.subplots(figsize=(18, 6))
                    ax.plot(dt[il_key], linewidth=1.5)
                    ax.set_xlim(0, span)
                    ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                    ax.set_xlabel('Day', fontsize=18)
                    buf = io.BytesIO()
                    fig.savefig(buf, format='png')
                    buf.seek(0)
                    dt[plot_key] = base64.b64encode(buf.read()).decode('utf-8')
                    buf.close()
                    plt.close()
 
                for fmid in dt['first_multiple_inventory_data']:
                    fig, ax = plt.subplots(figsize=(18, 6))
                    ax.plot(fmid['inventory'], linewidth=1.5)
                    ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                    ax.set_xlabel('Day', fontsize=18)
                    buf = io.BytesIO()
                    fig.savefig(buf, format='png')
                    buf.seek(0)
                    fmid['first_inventory_level_plot'] = base64.b64encode(buf.read()).decode('utf-8')
                    buf.close()
                    plt.close()
 
                for mid in dt['multiple_inventory_data']:
                    new_inv = []
                    cur     = sum(mid['purchases']) - (mid['sales'][0] if mid['sales'] else 0)
                    new_inv.append(cur)
                    for sale in mid['sales'][1:]:
                        cur -= sale
                        new_inv.append(cur)
                    mid['inventory'] = new_inv
 
                    fig, ax = plt.subplots(figsize=(18, 6))
                    ax.plot(mid['inventory'], linewidth=1.5)
                    ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                    ax.set_xlabel('Day', fontsize=18)
                    buf = io.BytesIO()
                    fig.savefig(buf, format='png')
                    buf.seek(0)
                    mid['inventory_level_plot'] = base64.b64encode(buf.read()).decode('utf-8')
                    buf.close()
                    plt.close()
 
            context = {
                'data_all':                      data_all,
                'total_data':                    total_data,
                'first_outlet_inventory_levels': first_outlet_inventory_levels,
                'outlet_inventory_levels':       outlet_inventory_levels,
                'first_total_order':             sum(i['first_c_order']          for i in total_data),
                'first_total_hold':              sum(i['first_c_hold']           for i in total_data),
                'first_total_stockout':          sum(i['first_c_stockout']       for i in total_data),
                'first_total_all':               sum(i['first_c_total']          for i in total_data),
                'first_total_calc_duration':     format_seconds(sum(i['first_calc_duration']  for i in total_data)),
                'first_total_purchases_freq':    sum(i['first_purchases_freq']   for i in total_data),
                'first_total_purchases_total':   sum(i['first_purchases_total']  for i in total_data),
                'first_total_stockout_total':    sum(i['first_stockout_total']   for i in total_data),
                'total_order':                   sum(i['c_order']       for i in total_data),
                'total_hold':                    sum(i['c_hold']        for i in total_data),
                'total_stockout':                sum(i['c_stockout']    for i in total_data),
                'total_all':                     sum(i['c_total']       for i in total_data),
                'total_calc_duration':           format_seconds(sum(i['best_calc_duration']   for i in total_data)),
                'total_purchases_freq':          sum(i['purchases_freq']  for i in total_data),
                'total_purchases_total':         sum(i['purchases_total'] for i in total_data),
                'total_stockout_total':          sum(i['stockout_total']  for i in total_data),
                'pso_used':                      use_pso,
            }
 
            return render(request, 'inventory_collab/calculation_collab.html', context)
 
        # ---------------------------------------------------------------- #
        # Non-superadmin branch
        # ---------------------------------------------------------------- #
        else:
            try:
                outlet_id = request.user.employee.outlet_id
                items     = Item.objects.filter(type="JADI")
                array     = []
 
                for item in items:
                    sales           = Sales.objects.filter(outlet_id=outlet_id, item_id=item.id)
                    sales_list_raw  = [sale.amount for sale in sales]
                    total_sales     = sum(sales_list_raw)
                    standar_deviasi = (np.std(sales_list_raw) if len(sales_list_raw) > 1
                                       else (sales_list_raw[0] if sales_list_raw else 1))
 
                    array.append({
                        'nama_barang':      item.name,
                        'biaya_pesan':      item.biaya_pesan,
                        'biaya_order':      item.biaya_pesan,
                        'permintaan_baku':  total_sales,
                        'biaya_simpan':     2000,
                        'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                        'harga_produk':     item.price,
                        'lead_time':        item.lead_time / 100,
                        'standar_deviasi':  standar_deviasi,
                    })
            except Exception as e:
                messages.error(request, f"An error occurred: {str(e)}")
                return redirect(request.META.get('HTTP_REFERER', '/'))
 
            data = []
            for x in array:
                product = dict(x)
 
                item_obj       = Item.objects.get(name=product['nama_barang'])
                sales_data     = (Sales.objects.filter(outlet_id=outlet_id, item_id=item_obj.id)
                                  .values('created_at').annotate(total_sales=Sum('amount')))
                purchases_data = (Purchase.objects.filter(outlet_id=outlet_id, item_id=item_obj.id)
                                  .values('created_at').annotate(total_purchases=Sum('amount')))
 
                sales_dict     = {s['created_at'].date(): s['total_sales']     for s in sales_data}
                purchases_dict = {p['created_at'].date(): p['total_purchases'] for p in purchases_data}
 
                start_date = min(sales_dict.keys(), default=datetime.today().date())
                end_date   = start_date + timedelta(days=59)
 
                daily_sales     = []
                daily_purchases = []
                cur = start_date
                while cur <= end_date:
                    daily_sales.append(sales_dict.get(cur, 0))
                    daily_purchases.append(purchases_dict.get(cur, 0))
                    cur += timedelta(days=1)
 
                # PSO runs once per product for non-superadmin too
                if use_pso:
                    try:
                        best_params, _, _ = pso_optimize_hyperparameters(
                            product, daily_sales, daily_purchases,
                            n_particles     = pso_n_particles,
                            n_iters         = pso_n_iters,
                            stockout_weight = stockout_weight,
                        )
                        final_pop = max(best_params['population_size'], pop_size)
                        final_gen = max(best_params['num_generations'],  num_generations)
                        final_cr  = best_params['crossover_rate']
                        final_mr  = best_params['mutation_rate']
                        pso_meta  = {
                            'used':        True,
                            'best_params': best_params,
                            'pso_duration': 0.0,
                        }
                    except Exception:
                        final_pop, final_gen = pop_size, num_generations
                        final_cr,  final_mr  = crossover_rate, mutation_rate
                        pso_meta = {'used': False, 'best_params': None, 'pso_duration': 0.0}
                else:
                    final_pop, final_gen = pop_size, num_generations
                    final_cr,  final_mr  = crossover_rate, mutation_rate
                    pso_meta = {'used': False, 'best_params': None, 'pso_duration': 0.0}
 
                ga_result = genetic_algorithm(
                    product, final_pop, final_gen, final_cr, final_mr,
                    daily_sales, daily_purchases,
                )
 
                (_, _, _, _, _,
                 inventory_level_list, purchases_list, sales_list,
                 tot_dmd, tot_lost, max_inventory,
                 purchases_freq, purchases_total, restock_data,
                 best_product, best_demand,
                 best_total_cost, best_to,
                 best_R, best_s, best_S, best_T,
                 first_R, first_s, first_S, first_T,
                 first_purchases_freq, first_total_lost, first_demand,
                 first_purchases_total,
                 first_inventory_level_list, first_restock_data,
                 first_calc_duration, best_calc_duration) = ga_result
 
                T_use = 60
 
                # FIRST cost
                first_half_demand     = first_demand[:T_use]
                first_total_demand    = round(sum(first_half_demand))
                first_mean_daily      = np.mean(first_half_demand) if first_half_demand else 0
                first_std_monthly     = np.std(first_half_demand, ddof=1) if len(first_half_demand) > 1 else 0
                first_std_daily       = first_std_monthly / np.sqrt(T_use) if T_use > 0 else 1e-9
                first_total_daily_dmd = round(first_total_demand / T_use) if T_use > 0 else 0
 
                fp_freq        = max(first_purchases_freq, 1)
                first_c_order  = 35000 * (T_use / (fp_freq * first_R))
                first_c_hold   = (product["biaya_simpan"] * ((first_S + first_s) / 2)
                                  + (first_total_demand * first_R) / fp_freq)
                first_total_so = round(sum(first_total_lost))
 
                if first_std_daily > 0:
                    def integrand_f(x):
                        return (x - first_total_daily_dmd) * norm.pdf(x, first_mean_daily, first_std_daily)
                    E_Rv_f, _ = quad(integrand_f, first_total_daily_dmd, np.inf)
                else:
                    E_Rv_f = 0.0
                first_c_stockout = product["biaya_kekurangan"] * E_Rv_f
                first_c_total    = first_c_order + first_c_hold + first_c_stockout
 
                # BEST cost
                half_demand     = best_demand[:T_use]
                total_dem_b     = round(sum(half_demand))
                mean_daily      = np.mean(half_demand) if half_demand else 0
                std_monthly     = np.std(half_demand, ddof=1) if len(half_demand) > 1 else 0
                std_daily       = std_monthly / np.sqrt(T_use) if T_use > 0 else 1e-9
                total_daily_dmd = round(total_dem_b / T_use) if T_use > 0 else 0
 
                mod_pf     = max(purchases_freq, 1)
                c_order    = 35000 * (T_use / (mod_pf * best_R))
                c_hold     = (product["biaya_simpan"] * ((best_S + best_s) / 2)
                              + (total_dem_b * best_R) / mod_pf)
                total_so   = round(sum(tot_lost))
 
                if std_daily > 0:
                    def integrand_b(x):
                        return (x - total_daily_dmd) * norm.pdf(x, mean_daily, std_daily)
                    E_Rv_b, _ = quad(integrand_b, total_daily_dmd, np.inf)
                else:
                    E_Rv_b = 0.0
                c_stockout = product["biaya_kekurangan"] * E_Rv_b
                c_total    = c_order + c_hold + c_stockout
 
                inventory_level_plot = _plot_inventory_level(inventory_level_list, best_S, T_use)
 
                data.append({
                    'nama_barang':          product["nama_barang"],
                    'first_c_order':        round(first_c_order),
                    'first_c_hold':         round(first_c_hold),
                    'first_c_stockout':     round(first_c_stockout),
                    'first_c_total':        round(first_c_total),
                    'c_order':              round(c_order),
                    'c_hold':               round(c_hold),
                    'c_stockout':           round(c_stockout),
                    'c_total':              round(c_total),
                    'purchases_freq':       purchases_freq,
                    'purchases_total':      purchases_total,
                    'stockout_total':       total_so,
                    'inventory_level_plot': inventory_level_plot,
                    'pso_used':             pso_meta['used'],
                    'pso_best_params':      pso_meta['best_params'],
                    'pso_duration':         round(pso_meta['pso_duration'], 2),
                })
 
            return render(request, 'inventory_collab/calculation.html', {'data': data})
 
    return render(request, 'inventory_collab/index.html', {'data': ''})

def inventory_collab_input_view(request):
    if request.method == 'POST':
        array = []
        data = []

        # Genetic Algorithm Calculation
        pop_size = int(request.POST['population_size'])
        num_generations = int(request.POST['num_generations'])
        crossover_rate = float(request.POST['crossover_rate'])
        mutation_rate = float(request.POST['mutation_rate'])

        # Outlets
        # main_outlet = Outlet.objects.filter(id=3)
        outlets = Outlet.objects.all()

        if request.user.employee.role == 'superadmin':
            # Initialize a dictionary to hold the aggregated total data
            total_data_dict = {}

            # Initialize a dictionary to store the outlet's combined inventory levels
            first_outlet_inventory_levels = {}
            outlet_inventory_levels = {}

            data_all = []
            for outlet in outlets:
                biaya_simpan = 0
                if (outlet.id == 3):
                    biaya_simpan = 5000
                elif (outlet.id == 5):
                    biaya_simpan = 1800
                elif (outlet.id == 6):
                    biaya_simpan = 2000
                elif (outlet.id == 7):
                    biaya_simpan = 1500

                biaya_order = 0
                if (outlet.id == 3):
                    biaya_order = 20000
                else:
                    biaya_order = 10000

                # outlet = outlets[0]
                data_outlet = []
                
                # Initialize an empty list to hold the combined inventory levels for this outlet
                first_combined_inventory_level = [0] * 60
                combined_inventory_level = [0] * 60

                # try:
                # Reset data for the current outlet
                data = []
                
                # Fetch items
                # items = Item.objects.filter(type="JADI")

                array = []
            data = []

            read_file = request.FILES['file']
            csv_data = pd.read_csv(read_file, header=1, encoding="UTF-8")

            for dt in csv_data.values:
                array_data = {}
                array_data['nama_barang'] = dt[1]
                array_data['biaya_pesan'] = dt[2]
                array_data['permintaan_baku'] = dt[3]
                array_data['biaya_simpan'] = dt[4]
                array_data['biaya_kekurangan'] = dt[5]
                array_data['harga_material'] = dt[6]
                array_data['lead_time'] = dt[7] / 100
                array_data['standar_deviasi'] = dt[8]

                array.append(array_data)

            for x in array:
                nama_barang = x['nama_barang']
                biaya_pesan = x['biaya_pesan']
                if x['permintaan_baku'] == 0 :
                    permintaan_baku = 1
                else :
                    permintaan_baku = x['permintaan_baku'] 
                
                biaya_simpan = x['biaya_simpan']
                biaya_kekurangan = x['biaya_kekurangan']
                harga_material = x['harga_material']
                lead_time = x['lead_time']
                standar_deviasi = x['standar_deviasi']
                
                for item in items:
                    # item = items[3]
                    # Fetch sales and sales data directly from the database
                    sales = Sales.objects.filter(outlet_id=outlet.id, item_id=item.id)
                    outlet_item = OutletItem.objects.filter(outlet=outlet.id, item=item.id).first()

                    # return HttpResponse(outlet_item.id)

                    sales_list = [sale.amount for sale in sales]
                    total_sales = sum(sales_list)
                    standar_deviasi = np.std(sales_list) if len(sales_list) > 1 else (sales_list[0] if sales_list else 1)

                    # Fetch sales data
                    sales_data = Sales.objects.filter(outlet_id=outlet.id, item_id=item.id).values('created_at').annotate(total_sales=Sum('amount'))

                    # Fetch pruchases data
                    purchases_data = Purchase.objects.filter(outlet_id=outlet.id, item_id=item.id).values('created_at').annotate(total_purchases=Sum('amount'))

                    # Convert to a dictionary with date as key
                    sales_dict = {sale['created_at'].date(): sale['total_sales'] for sale in sales_data}
                    purchases_dict = {purchase['created_at'].date(): purchase['total_purchases'] for purchase in purchases_data}

                    # Determine the date range (assuming you want the last 7 days)
                    start_date = min(sales_dict.keys(), default=datetime.today().date())
                    end_date = start_date + timedelta(days=59)

                    # Generate the daily sales array
                    daily_sales = []
                    current_date = start_date
                    while current_date <= end_date:
                        daily_sales.append(sales_dict.get(current_date, 0))  # Get sales or default to 0
                        current_date += timedelta(days=1)

                    # Generate the daily purchases array
                    daily_purchases = []
                    current_date = start_date
                    while current_date <= end_date:
                        daily_purchases.append(purchases_dict.get(current_date, 0))  # Get purchases or default to 0
                        current_date += timedelta(days=1)

                    # Prepare data for periodic review processing
                    product = {
                        'nama_barang': item.name,
                        'biaya_pesan': item.biaya_pesan,
                        'permintaan_baku': total_sales,
                        'biaya_simpan': biaya_simpan,  # Static value as per your example
                        'biaya_order': biaya_order,
                        'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                        'harga_produk': item.price,
                        # 'lead_time': (10 - outlet_item.lead_time) / 100 if outlet_item.lead_time < 10 else (20 - outlet_item.lead_time) / 100,  # Adjusted for percentage
                        'lead_time': outlet_item.lead_time / 100,
                        'standar_deviasi': standar_deviasi,
                    }

                    # return HttpResponse(product['permintaan_baku'])
                    # return HttpResponse(sum(daily_sales))

                    # try:
                    (tp_list, to_list, data_list, demand_result_list, orders_lost_list, 
                    inventory_level_list, total_demand, total_lost, max_inventory, 
                    purchases_freq, purchases_total, restock_data, best_product, best_demand, 
                    best_total_cost, best_to, best_R, best_s, best_S, best_T, first_R, first_s, first_S, first_T, first_purchases_freq, first_total_lost, first_demand, first_purchases_total, first_inventory_level_list, first_restock_data, first_calc_duration, best_calc_duration) = genetic_algorithm(
                        product, pop_size, num_generations, crossover_rate, mutation_rate, daily_sales, daily_purchases
                    )

                    # temp = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate, daily_sales)

                    # first_demand, first_R, first_s, first_S = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate, daily_sales)

                    # temp_data = {
                    #     'first_demand': first_demand,
                    #     'first_R': first_R,
                    #     'first_s': first_s,
                    #     'first_S': first_S
                    # }

                    # return HttpResponse(temp * 1000)
                    # return HttpResponse(', '.join(map(str, daily_sales)))
                    # return JsonResponse(temp_data)

                    # return HttpResponse(temp_R)
                    # return HttpResponse(', '.join(map(str, sales_list)))

                    # FIRST DATA
                    temp_first_start_time = time.time()

                    first_half_demand = first_demand[:first_T]
                    first_total_demand = round(sum(first_half_demand))

                    # Separate non-zero values and zeros
                    first_restock_non_zero_values = [x for x in first_restock_data if x != 0]
                    first_restock_zeros = [x for x in first_restock_data if x == 0]

                    # Concatenate the non-zero values with the zeros
                    first_restock_result = first_restock_non_zero_values + first_restock_zeros

                    # List to store daily stock values
                    first_stock_history = []

                    # Processing stock and storing history
                    first_stock = 0
                    for i in range(first_T):
                        first_stock += round(first_restock_result[i])  # Add the value from array1
                        first_stock -= round(first_restock_data[i])  # Subtract the value from array2
                        first_stock_history.append(first_stock)  # Store the updated stock value

                    # Add the product's inventory level to the combined list (sum or average)
                    for day in range(min(first_T, len(first_inventory_level_list))):  # Limit to first_T days
                        first_combined_inventory_level[day] += first_inventory_level_list[day]

                    first_mean_daily_demand = np.mean(first_half_demand)
                    first_std_dev_monthly_demand = np.std(first_half_demand, ddof=1)
                    first_std_dev_daily_demand = first_std_dev_monthly_demand / np.sqrt(first_T)
                    first_total_daily_demand = round(sum(first_half_demand) / first_T)

                    # Plotting inventory level for outlet
                    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                    plt.plot(first_inventory_level_list, linewidth=1.5)
                    plt.axhline(first_S, linewidth=2, color="grey", linestyle=":")
                    plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                    plt.xlim(0, first_T)
                    ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                    ax.set_xlabel('Day', fontsize=18)

                    flike = io.BytesIO()
                    plt.savefig(flike)
                    first_inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
                    plt.switch_backend('agg')
                    plt.close()

                    # return HttpResponse(first_R)
                    
                    if first_purchases_freq == 0:
                        first_purchases_freq = 1

                    # Calculate biaya order
                    first_c_order = biaya_order * (first_T / (first_purchases_freq * first_R))

                    # Calculate biaya simpan
                    # first_c_hold = product["biaya_simpan"] * round((firstS + firsts) / 2) + round((first_total_demand * firstR) / purchases_freq)
                    first_c_hold = biaya_simpan * ((first_S + first_s) / 2) + ((first_total_demand * first_R) / first_purchases_freq)
                    
                    # Calculate biaya stockout
                    first_total_stockout = round(sum(first_total_lost))

                    def integrand(x):
                        first_demand_pdf = norm.pdf(x, first_mean_daily_demand, first_std_dev_daily_demand)
                        # return demand_pdf
                        return (x - first_total_daily_demand) * first_demand_pdf

                    # temp = integrand(total_daily_demand)
                    E_Rv, error = quad(integrand, first_total_daily_demand, np.inf)
                    first_c_stockout = product["biaya_kekurangan"] * E_Rv

                    first_c_total = first_c_order +  first_c_hold + first_c_stockout

                    temp_first_end_time = time.time()
                    first_calc_duration += temp_first_end_time - temp_first_start_time
                    # END FIRST DATA

                    # BEST DATA
                    temp_best_start_time = time.time()

                    half_demand = best_demand[:best_T]
                    tot_demand = round(sum(half_demand))

                    # Separate non-zero values and zeros
                    restock_non_zero_values = [x for x in restock_data if x != 0]
                    restock_zeros = [x for x in restock_data if x == 0]

                    # Concatenate the non-zero values with the zeros
                    restock_result = restock_non_zero_values + restock_zeros

                    # List to store daily stock values
                    stock_history = []

                    # Processing stock and storing history
                    stock = 0
                    for i in range(best_T):
                        stock += round(restock_result[i])  # Add the value from array1
                        stock -= round(restock_data[i])  # Subtract the value from array2
                        stock_history.append(stock)  # Store the updated stock value

                    # return HttpResponse(', '.join(map(str, restock_data)))
                    # return HttpResponse(restock_data)

                    # Add the product's inventory level to the combined list (sum or average)
                    for day in range(min(best_T, len(inventory_level_list))):  # Limit to best_T days
                        combined_inventory_level[day] += inventory_level_list[day]

                    mean_daily_demand = np.mean(half_demand)
                    std_dev_monthly_demand = np.std(half_demand, ddof=1)
                    std_dev_daily_demand = std_dev_monthly_demand / np.sqrt(best_T)
                    total_daily_demand = round(sum(half_demand) / best_T)

                    # Plotting inventory level for outlet
                    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                    plt.plot(inventory_level_list, linewidth=1.5)
                    plt.axhline(best_S, linewidth=2, color="grey", linestyle=":")
                    plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                    plt.xlim(0, best_T)
                    ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                    ax.set_xlabel('Day', fontsize=18)

                    flike = io.BytesIO()
                    plt.savefig(flike)
                    inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
                    plt.switch_backend('agg')
                    plt.close()

                    if purchases_freq <= 0:
                        purchases_freq = 1
                    
                    # Cost Calculation
                    c_order = biaya_order * (best_T / (purchases_freq * best_R))
                    # c_hold = product["biaya_simpan"] * round((best_S + best_s) / 2) + round((tot_demand * best_R) / purchases_freq)
                    c_hold = biaya_simpan * round((best_S + best_s) / 2) + round((tot_demand * best_R) / purchases_freq)
                    
                    total_stockout = round(sum(total_lost))

                    def integrand(x):
                        demand_pdf = norm.pdf(x, mean_daily_demand, std_dev_daily_demand)
                        return (x - total_daily_demand) * demand_pdf

                    E_Rv, error = quad(integrand, total_daily_demand, np.inf)
                    c_stockout = product["biaya_kekurangan"] * E_Rv

                    c_total = c_order + c_hold + c_stockout

                    temp_best_end_time = time.time()
                    best_calc_duration += temp_best_end_time - temp_best_start_time
                    # END BEST DATA

                    # Prepare item data
                    item_data = {
                        'first_c_order': round(first_c_order),
                        'first_c_hold': round(first_c_hold),
                        'first_c_stockout': round(first_c_stockout),
                        'first_c_total': round(first_c_total),
                        'first_purchases_freq': round(first_purchases_freq),
                        'first_purchases_total': round(first_purchases_total),
                        'first_stockout_total': round(first_total_stockout),
                        'first_stockout_mean': first_total_stockout,
                        'first_restock_data': [a - b for a, b in zip(half_demand, first_restock_data)],
                        'first_stock_history': first_stock_history,
                        'first_timespan': first_T,
                        'first_calc_duration': first_calc_duration,
                        'c_order': round(c_order),
                        'c_hold': round(c_hold),
                        'c_stockout': round(c_stockout),
                        'c_total': round(c_total),
                        'purchases_freq': round(purchases_freq),
                        'purchases_total': round(purchases_total),
                        'stockout_total': round(total_stockout),
                        'stockout_mean': total_stockout,
                        'restock_data': [a - b for a, b in zip(half_demand, restock_data)],
                        'stock_history': stock_history,
                        'timespan': best_T,
                        'best_calc_duration': best_calc_duration,
                    }

                    # Aggregate the data by product name (nama_barang)
                    if product["nama_barang"] in total_data_dict:
                        total_data_dict[product["nama_barang"]]['first_c_order'] += item_data['first_c_order']
                        total_data_dict[product["nama_barang"]]['first_c_hold'] += item_data['first_c_hold']
                        total_data_dict[product["nama_barang"]]['first_c_stockout'] += item_data['first_c_stockout']
                        total_data_dict[product["nama_barang"]]['first_c_total'] += item_data['first_c_total']
                        total_data_dict[product["nama_barang"]]['first_purchases_freq'] += item_data['first_purchases_freq']
                        total_data_dict[product["nama_barang"]]['first_purchases_total'] += item_data['first_purchases_total']
                        total_data_dict[product["nama_barang"]]['first_stockout_total'] += item_data['first_stockout_total']
                        total_data_dict[product["nama_barang"]]['first_stockout_mean'] += item_data['first_stockout_mean']
                        total_data_dict[product["nama_barang"]]['first_restock_data'] = [a + b for a, b in zip(total_data_dict[product["nama_barang"]]['first_restock_data'], item_data['first_restock_data'])]
                        total_data_dict[product["nama_barang"]]['first_stock_history'] = [a + b for a, b in zip(total_data_dict[product["nama_barang"]]['first_stock_history'], item_data['first_stock_history'])]
                        total_data_dict[product["nama_barang"]]['first_timespan'] = item_data['first_timespan'] if item_data['first_timespan'] < total_data_dict[product["nama_barang"]]['first_timespan'] else total_data_dict[product["nama_barang"]]['first_timespan']
                        total_data_dict[product["nama_barang"]]['first_calc_duration'] += item_data['first_calc_duration']
                        total_data_dict[product["nama_barang"]]['c_order'] += item_data['c_order']
                        total_data_dict[product["nama_barang"]]['c_hold'] += item_data['c_hold']
                        total_data_dict[product["nama_barang"]]['c_stockout'] += item_data['c_stockout']
                        total_data_dict[product["nama_barang"]]['c_total'] += item_data['c_total']
                        total_data_dict[product["nama_barang"]]['purchases_freq'] += item_data['purchases_freq']
                        total_data_dict[product["nama_barang"]]['purchases_total'] += item_data['purchases_total']
                        total_data_dict[product["nama_barang"]]['stockout_total'] += item_data['stockout_total']
                        total_data_dict[product["nama_barang"]]['stockout_mean'] += item_data['stockout_mean']
                        total_data_dict[product["nama_barang"]]['restock_data'] = [a + b for a, b in zip(total_data_dict[product["nama_barang"]]['restock_data'], item_data['restock_data'])]
                        total_data_dict[product["nama_barang"]]['stock_history'] = [a + b for a, b in zip(total_data_dict[product["nama_barang"]]['stock_history'], item_data['stock_history'])]
                        # total_data_dict[product["nama_barang"]]['timespan'] = item_data['timespan']
                        total_data_dict[product["nama_barang"]]['timespan'] = item_data['timespan'] if item_data['timespan'] < total_data_dict[product["nama_barang"]]['timespan'] else total_data_dict[product["nama_barang"]]['timespan']
                        total_data_dict[product["nama_barang"]]['best_calc_duration'] += item_data['best_calc_duration']
                    else:
                        total_data_dict[product["nama_barang"]] = {
                            'nama_barang': product["nama_barang"],
                            'first_c_order': item_data['first_c_order'],
                            'first_c_hold': item_data['first_c_hold'],
                            'first_c_stockout': item_data['first_c_stockout'],
                            'first_c_total': item_data['first_c_total'],
                            'first_purchases_freq': item_data['first_purchases_freq'],
                            'first_purchases_total': item_data['first_purchases_total'],
                            'first_stockout_total': item_data['first_stockout_total'],
                            'first_stockout_mean': item_data['first_stockout_mean'],
                            'first_restock_data': item_data['first_restock_data'],
                            'first_stock_history': item_data['first_stock_history'],
                            'first_timespan': item_data['first_timespan'],
                            'first_calc_duration': item_data['first_calc_duration'],
                            'c_order': item_data['c_order'],
                            'c_hold': item_data['c_hold'],
                            'c_stockout': item_data['c_stockout'],
                            'c_total': item_data['c_total'],
                            'purchases_freq': item_data['purchases_freq'],
                            'purchases_total': item_data['purchases_total'],
                            'stockout_total': item_data['stockout_total'],
                            'stockout_mean': item_data['stockout_mean'],
                            'restock_data': item_data['restock_data'],
                            'stock_history': item_data['stock_history'],
                            'timespan': item_data['timespan'],
                            'best_calc_duration': item_data['best_calc_duration'],
                        }
                    

                    # Append product data
                    data.append({
                        'nama_barang': product["nama_barang"],
                        'first_c_order': round(first_c_order),
                        'first_c_hold': round(first_c_hold),
                        'first_c_stockout': round(first_c_stockout),
                        'first_c_total': round(first_c_total),
                        'first_purchases_freq': round(first_purchases_freq),
                        'first_purchases_total': round(first_purchases_total),
                        'first_stockout_total': round(first_total_stockout),
                        'first_stockout_mean': first_total_stockout,
                        'first_timespan': first_T,
                        'first_calc_duration': first_calc_duration,
                        'first_inventory_level_plot': first_inventory_level_plot,
                        'c_order': round(c_order),
                        'c_hold': round(c_hold),
                        'c_stockout': round(c_stockout),
                        'c_total': round(c_total),
                        'purchases_freq': round(purchases_freq),
                        'purchases_total': round(purchases_total),
                        'stockout_total': round(total_stockout),
                        'stockout_mean': total_stockout,
                        'timespan': best_T,
                        'best_calc_duration': best_calc_duration,
                        'inventory_level_plot': inventory_level_plot,
                    })
                    # except Exception as e:
                    #     messages.error(request, f"Error in genetic algorithm: {str(e)}")
                    #     continue

                # FIRST DATA
                # After processing all products for this outlet, generate the plot
                fig, ax = plt.subplots(figsize=(18, 6))
                ax.plot(first_combined_inventory_level, linewidth=1.5)
                ax.set_xlim(0, first_T)  # Ensure it stays within first_T days
                ax.set_ylabel('Demand Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                # Convert the plot to a PNG image and encode it in base64
                buf = io.BytesIO()
                plt.savefig(buf, format='png')
                buf.seek(0)
                first_outlet_restock_plot = base64.b64encode(buf.read()).decode('utf-8')
                buf.close()

                # BEST DATA
                # After processing all products for this outlet, generate the plot
                fig, ax = plt.subplots(figsize=(18, 6))
                ax.plot(combined_inventory_level, linewidth=1.5)
                ax.set_xlim(0, best_T)  # Ensure it stays within best_T days
                ax.set_ylabel('Demand Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                # Convert the plot to a PNG image and encode it in base64
                buf = io.BytesIO()
                plt.savefig(buf, format='png')
                buf.seek(0)
                outlet_restock_plot = base64.b64encode(buf.read()).decode('utf-8')
                buf.close()

                # Calculate totals manually
                # FIRST DATA
                first_total_order = sum(item['first_c_order'] for item in data)
                first_total_hold = sum(item['first_c_hold'] for item in data)
                first_total_stockout = sum(item['first_c_stockout'] for item in data)
                first_total_all = sum(item['first_c_total'] for item in data)
                first_total_purchases_freq = sum(item['first_purchases_freq'] for item in data)
                first_total_purchases_total = sum(item['first_purchases_total'] for item in data)
                first_total_stockout_total = sum(item['first_stockout_total'] for item in data)
                first_total_calc_duration = sum(item['first_calc_duration'] for item in data)

                # BEST DATA
                total_order = sum(item['c_order'] for item in data)
                total_hold = sum(item['c_hold'] for item in data)
                total_stockout = sum(item['c_stockout'] for item in data)
                total_all = sum(item['c_total'] for item in data)
                total_purchases_freq = sum(item['purchases_freq'] for item in data)
                total_purchases_total = sum(item['purchases_total'] for item in data)
                total_stockout_total = sum(item['stockout_total'] for item in data)
                total_calc_duration = sum(item['best_calc_duration'] for item in data)
                
                # Append outlet data
                data_outlet.append(data)
                data_all.append({
                    'outlet': outlet,
                    'data': data,
                    'first_restock_plot': first_outlet_restock_plot,
                    'restock_plot': outlet_restock_plot,
                    'first_total_order': first_total_order,
                    'first_total_hold': first_total_hold,
                    'first_total_stockout': first_total_stockout,
                    'first_total_all': first_total_all,
                    'first_total_purchases_freq': first_total_purchases_freq,
                    'first_total_purchases_total': first_total_purchases_total,
                    'first_total_stockout_total': first_total_stockout_total,
                    'first_total_calc_duration': first_total_calc_duration,
                    'total_order': total_order,
                    'total_hold': total_hold,
                    'total_stockout': total_stockout,
                    'total_all': total_all,
                    'total_purchases_freq': total_purchases_freq,
                    'total_purchases_total': total_purchases_total,
                    'total_stockout_total': total_stockout_total,
                    'total_calc_duration': total_calc_duration,
                })
                # except Exception as e:
                #     messages.error(request, f"Error processing outlet {outlet.id}: {str(e)}")
                #     continue

            # After processing all outlets, calculate totals/averages if needed
            total_data = list(total_data_dict.values())

            for dt in total_data:
                # Calculate and plot outlet inventory level
                # inventory_level_list_vendor, tot_dmd_vendor, tot_lost_vendor, max_inventory_vendor, purchases_vendor = calculate_inventory_levels_vendor(dt['restock_data'])

                # return HttpResponse(', '.join(map(str, dt['stock_history'])))

                # FIRST DATA
                # Plotting inventory level for vendor
                first_stock_history_month = dt['first_stock_history'][:dt['first_timespan']]
                first_stockout_mean = dt['first_stockout_mean']

                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                plt.plot(first_stock_history_month, linewidth=1.5)
                # plt.axhline(5000, linewidth=2, color="grey", linestyle=":")
                # plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0, dt['first_timespan'])
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                flike = io.BytesIO()
                plt.savefig(flike)
                dt['first_inventory_level_plot'] = base64.b64encode(flike.getvalue()).decode()
                plt.switch_backend('agg')
                plt.close()

                # grafik orders lost
                f_lost = plt.figure(figsize=(6, 4))
                gs = f_lost.add_gridspec(1, 1)
                ax = f_lost.add_subplot(gs[0, 0])
                sns.distplot(first_stockout_mean,kde=False, color = "#097969")
                ax.set_title(f'Total Stockout : Mean {np.mean(first_stockout_mean):.3f}')
                ax.axvline(x = np.mean(first_stockout_mean), color='k', alpha = .5, ls = '--')
                plt.tight_layout()
                flike = io.BytesIO()
                f_lost.savefig(flike)
                dt['first_lost_order_plot'] = base64.b64encode(flike.getvalue()).decode()
                plt.close()

                # BEST DATA
                # Plotting inventory level for vendor
                stock_history_month = dt['stock_history'][:dt['timespan']]
                stockout_mean = dt['stockout_mean']

                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                plt.plot(stock_history_month, linewidth=1.5)
                # plt.axhline(5000, linewidth=2, color="grey", linestyle=":")
                # plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0, dt['timespan'])
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                flike = io.BytesIO()
                plt.savefig(flike)
                dt['inventory_level_plot'] = base64.b64encode(flike.getvalue()).decode()
                plt.switch_backend('agg')
                plt.close()

                # grafik orders lost
                f_lost = plt.figure(figsize=(6, 4))
                gs = f_lost.add_gridspec(1, 1)
                ax = f_lost.add_subplot(gs[0, 0])
                sns.distplot(stockout_mean,kde=False, color = "#097969")
                ax.set_title(f'Total Stockout : Mean {np.mean(stockout_mean):.3f}')
                ax.axvline(x = np.mean(stockout_mean), color='k', alpha = .5, ls = '--')
                plt.tight_layout()
                flike = io.BytesIO()
                f_lost.savefig(flike)
                dt['lost_order_plot'] = base64.b64encode(flike.getvalue()).decode()
                plt.close()

            # Calculate totals manually
            # FIRST DATA
            first_total_order = sum(item['first_c_order'] for item in total_data)
            first_total_hold = sum(item['first_c_hold'] for item in total_data)
            first_total_stockout = sum(item['first_c_stockout'] for item in total_data)
            first_total_all = sum(item['first_c_total'] for item in total_data)
            first_total_calc_duration = sum(item['first_calc_duration'] for item in total_data)
            first_total_purchases_freq = sum(item['first_purchases_freq'] for item in total_data)
            first_total_purchases_total = sum(item['first_purchases_total'] for item in total_data)
            first_total_stockout_total = sum(item['first_stockout_total'] for item in total_data)

            # BEST DATA
            total_order = sum(item['c_order'] for item in total_data)
            total_hold = sum(item['c_hold'] for item in total_data)
            total_stockout = sum(item['c_stockout'] for item in total_data)
            total_all = sum(item['c_total'] for item in total_data)
            total_calc_duration = sum(item['best_calc_duration'] for item in total_data)
            total_purchases_freq = sum(item['purchases_freq'] for item in total_data)
            total_purchases_total = sum(item['purchases_total'] for item in total_data)
            total_stockout_total = sum(item['stockout_total'] for item in total_data)

            # Render the context
            context = {
                'data_all': data_all,
                'total_data': total_data,
                'first_outlet_inventory_levels': first_outlet_inventory_levels,
                'outlet_inventory_levels': outlet_inventory_levels,
                'first_total_order': first_total_order,
                'first_total_hold': first_total_hold,
                'first_total_stockout': first_total_stockout,
                'first_total_all': first_total_all,
                'first_total_calc_duration': format_seconds(first_total_calc_duration),
                'first_total_purchases_freq': first_total_purchases_freq,
                'first_total_purchases_total': first_total_purchases_total,
                'first_total_stockout_total': first_total_stockout_total,
                'total_order': total_order,
                'total_hold': total_hold,
                'total_stockout': total_stockout,
                'total_all': total_all,
                'total_calc_duration': format_seconds(total_calc_duration),
                'total_purchases_freq': total_purchases_freq,
                'total_purchases_total': total_purchases_total,
                'total_stockout_total': total_stockout_total,
            }

            return render(request, 'inventory_collab/calculation_collab.html', context)
        else:
            try:
                outlet_id = request.user.employee.outlet_id
                array = []
                
                # Fetch items and sales data directly from the database
                items = Item.objects.filter(type="JADI")

                for item in items:
                    sales = Sales.objects.filter(outlet_id=outlet_id, item_id=item.id)
                    sales_sum = Sales.objects.filter(outlet_id=outlet_id, item_id=item.id).aggregate(total_quantity=Sum('amount'))

                    sales_list = [sale.amount for sale in sales]
                    
                    # Calculate total sales and standard deviation
                    total_sales = sum(sales_list)
                    standar_deviasi = np.std(sales_list) if len(sales_list) > 1 else (sales_list[0] if sales_list else 1)

                    # Prepare data for periodic review processing
                    array_data = {
                        'nama_barang': item.name,
                        'biaya_pesan': item.biaya_pesan,
                        'permintaan_baku': total_sales,
                        'biaya_simpan': 2000,  # Static value as per your example
                        'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                        'harga_produk': item.price,
                        'lead_time': item.lead_time / 100,  # Adjusted for percentage
                        'standar_deviasi': standar_deviasi,
                    }

                    array.append(array_data)
            except Exception as e:
                messages.error(request, f"An error occurred: {str(e)}")
                return redirect(request.META.get('HTTP_REFERER', '/'))

            for index, x in enumerate(array):
                product = {}
                product["nama_barang"] = x['nama_barang']
                product["biaya_pesan"] = x['biaya_pesan']
                product["permintaan_baku"] = x['permintaan_baku']
                product["biaya_simpan"] = x['biaya_simpan']
                product["biaya_kekurangan"] = x['biaya_kekurangan']
                product["harga_produk"] = x['harga_produk']
                product["lead_time"] = x['lead_time']
                product["standar_deviasi"] = x['standar_deviasi']
                
                tp_list, to_list, data_list, demand_result_list, orders_lost_list, inventory_level_list, total_demand, total_lost, max_inventory, purchases_freq, purchases_total, best_product, best_demand, best_total_cost, best_to, best_R, best_s, best_S, first_R, first_s, first_S, first_purchases_freq, first_total_lost, first_demand, first_purchases_total, first_inventory_level_list, first_restock_data, first_calc_duration, best_calc_duration = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

                # FIRST DATA
                first_half_demand = first_demand[:60]
                first_total_demand = round(sum(first_half_demand))
                
                first_mean_daily_demand = np.mean(first_half_demand)
                first_std_dev_monthly_demand = np.std(first_half_demand, ddof=1)
                first_std_dev_daily_demand = first_std_dev_monthly_demand / np.sqrt(60)
                first_total_daily_demand = round(sum(first_half_demand) / 60)

                # BEST DATA
                half_demand = best_demand[:60]
                total_demand = round(sum(half_demand))
                
                mean_daily_demand = np.mean(half_demand)
                std_dev_monthly_demand = np.std(half_demand, ddof=1)
                std_dev_daily_demand = std_dev_monthly_demand / np.sqrt(60)
                total_daily_demand = round(sum(half_demand) / 60)

                # return HttpResponse(total_demand)

                # FIRST DATA
                # grafik inventory level
                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18,6))
                plt.plot(first_inventory_level_list, linewidth = 1.5)
                plt.axhline(best_S, linewidth=2, color="grey", linestyle=":")
                plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0,60)
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                flike = io.BytesIO()
                plt.savefig(flike)
                inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
                plt.switch_backend('agg')
                plt.close()

                # BEST DATA
                # grafik inventory level
                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18,6))
                plt.plot(inventory_level_list, linewidth = 1.5)
                plt.axhline(best_S, linewidth=2, color="grey", linestyle=":")
                plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0,60)
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                flike = io.BytesIO()
                plt.savefig(flike)
                inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
                plt.switch_backend('agg')
                plt.close()

                # FIRST DATA
                # Calculate biaya order
                first_c_order = 35000 * (60 / (first_purchases_freq * first_R))

                # Calculate biaya simpan
                first_c_hold = product["biaya_simpan"] * ((first_S + first_s) / 2) + ((first_total_demand * first_R) / first_purchases_freq)
                
                # Calculate biaya stockout
                first_total_stockout = round(sum(total_lost))

                def integrand(x):
                    first_demand_pdf = norm.pdf(x, first_mean_daily_demand, first_std_dev_daily_demand)
                    # return demand_pdf
                    return (x - first_total_daily_demand) * first_demand_pdf

                # temp = integrand(total_daily_demand)
                E_Rv, error = quad(integrand, first_total_daily_demand, np.inf)
                first_c_stockout = product["biaya_kekurangan"] * E_Rv

                first_c_total = first_c_order +  first_c_hold + first_c_stockout

                # BEST DATA
                # Calculate biaya order
                c_order = 35000 * (60 / (purchases_freq * best_R))

                # Calculate biaya simpan
                c_hold = product["biaya_simpan"] * ((best_S + best_s) / 2) + ((total_demand * best_R) / purchases_freq)
                
                # Calculate biaya stockout
                total_stockout = round(sum(first_total_lost))

                def integrand(x):
                    demand_pdf = norm.pdf(x, mean_daily_demand, std_dev_daily_demand)
                    # return demand_pdf
                    return (x - total_daily_demand) * demand_pdf

                # temp = integrand(total_daily_demand)
                E_Rv, error = quad(integrand, total_daily_demand, np.inf)
                c_stockout = product["biaya_kekurangan"] * E_Rv

                c_total = c_order +  c_hold + c_stockout

                # return HttpResponse(E_Rv)
            
                temp = {
                    'nama_barang': product["nama_barang"],
                    'first_c_order': round(first_c_order),
                    'first_c_hold': round(first_c_hold),
                    'first_c_stockout': round(first_c_stockout),
                    'first_c_total': round(first_c_total),
                    'c_order': round(c_order),
                    'c_hold': round(c_hold),
                    'c_stockout': round(c_stockout),
                    'c_total': round(c_total),
                    'purchases_freq': purchases_freq,
                    'purchases_total': purchases_total,
                    'stockout_total': round(sum(total_lost)),
                    'inventory_level_plot': inventory_level_plot,
                }

                data.append(temp)
                
            context = {
                'data': data,
            }

            return render(request, 'inventory_collab/calculation.html', context)

    context = {
        'data': '',
    }

    return render(request, 'inventory_collab/index-input.html', context)

def _parse_post_float(post, key, default):
    """Read a float from POST data, falling back to default if blank or invalid."""
    val = post.get(key, '').strip()
    try:
        return float(val)
    except (ValueError, TypeError):
        return default

def _parse_post_int(post, key, default):
    """Read an int from POST data, falling back to default if blank or invalid."""
    val = post.get(key, '').strip()
    try:
        return int(val)
    except (ValueError, TypeError):
        return default

def format_seconds(seconds):
    return str(timedelta(seconds=round(seconds)))

def _evaluate_particle_global(position, products_data, stockout_weight=PSO_STOCKOUT_WEIGHT):
    """
    Evaluate a PSO particle against ALL products and return the average
    composite fitness. This ensures PSO finds hyperparameters that work
    well across the entire catalogue, not just one item.
    """
    pop_size, num_generations, crossover_rate, mutation_rate = _decode_particle(position)
    pop_size        = min(pop_size,        PSO_INNER_POP)
    num_generations = min(num_generations, PSO_INNER_GEN)

    scores = []
    for product_data, daily_sales, daily_purchases in products_data:
        try:
            result          = genetic_algorithm(
                product_data, pop_size, num_generations,
                crossover_rate, mutation_rate,
                daily_sales, daily_purchases,
            )
            best_total_cost = result[16]
            total_stockout  = round(sum(result[9]))
            scores.append(best_total_cost + stockout_weight * total_stockout)
        except Exception:
            scores.append(float('inf'))

    return np.mean(scores) if scores else float('inf')

def pso_optimize_hyperparameters_global(products_data,
                                         n_particles=PSO_N_PARTICLES,
                                         n_iters=PSO_N_ITERS,
                                         w=PSO_W, c1=PSO_C1, c2=PSO_C2,
                                         stockout_weight=PSO_STOCKOUT_WEIGHT):
    """
    Run PSO once across all products to find a single unified hyperparameter
    set. Each particle is scored as the average fitness across all items.

    Returns best_params dict, best_score, history.
    """
    lo  = [PSO_BOUNDS['population_size'][0], PSO_BOUNDS['num_generations'][0],
           PSO_BOUNDS['crossover_rate'][0],   PSO_BOUNDS['mutation_rate'][0]]
    hi  = [PSO_BOUNDS['population_size'][1], PSO_BOUNDS['num_generations'][1],
           PSO_BOUNDS['crossover_rate'][1],   PSO_BOUNDS['mutation_rate'][1]]
    dim = 4

    positions  = [[random.uniform(lo[d], hi[d]) for d in range(dim)] for _ in range(n_particles)]
    velocities = [[random.uniform(-(hi[d]-lo[d])*0.1, (hi[d]-lo[d])*0.1)
                   for d in range(dim)] for _ in range(n_particles)]

    personal_best_pos   = [p[:] for p in positions]
    personal_best_score = [
        _evaluate_particle_global(p, products_data, stockout_weight)
        for p in positions
    ]

    global_best_idx   = int(np.argmin(personal_best_score))
    global_best_pos   = personal_best_pos[global_best_idx][:]
    global_best_score = personal_best_score[global_best_idx]
    history           = [global_best_score]

    for _ in range(n_iters):
        for i in range(n_particles):
            r1 = [random.random() for _ in range(dim)]
            r2 = [random.random() for _ in range(dim)]

            velocities[i] = [
                w * velocities[i][d]
                + c1 * r1[d] * (personal_best_pos[i][d] - positions[i][d])
                + c2 * r2[d] * (global_best_pos[d]       - positions[i][d])
                for d in range(dim)
            ]
            positions[i] = _clip_particle([
                positions[i][d] + velocities[i][d] for d in range(dim)
            ])

            score = _evaluate_particle_global(positions[i], products_data, stockout_weight)

            if score < personal_best_score[i]:
                personal_best_score[i] = score
                personal_best_pos[i]   = positions[i][:]

            if score < global_best_score:
                global_best_score = score
                global_best_pos   = positions[i][:]

        history.append(global_best_score)

    pop_size, num_gen, cr, mr = _decode_particle(global_best_pos)
    return (
        {'population_size': pop_size, 'num_generations': num_gen,
         'crossover_rate': round(cr, 4), 'mutation_rate': round(mr, 4)},
        global_best_score,
        history,
    )