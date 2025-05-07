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
        "purchases"     : purchase_total,
        "sales"         : sales_total,
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
    user_id         = request.user.id
    # Ambil tanggal awal bulan ini
    start_of_month = timezone.now().replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    # Ambil tanggal awal bulan berikutnya
    start_of_next_month = (start_of_month + timedelta(days=32)).replace(day=1)

    # Filter data penjualan hanya untuk bulan ini
    sales = Sales.objects.filter(created_at__gte=start_of_month, created_at__lt=start_of_next_month, user_id=user_id)

    item_sales_count = {}

    for sale in sales:
        item_id = sale.item_id
        item_name = sale.item.name  # Sesuaikan dengan struktur model Anda
        item_sales_count[item_name] = item_sales_count.get(item_name, 0) + int(sale.amount)

    data = {'item_names': list(item_sales_count.keys()), 'sales_counts': list(item_sales_count.values())}
    return JsonResponse(data)

def get_purchase_data(request):
    # Ambil tanggal awal bulan ini
    start_of_month = timezone.now().replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    # Ambil tanggal awal bulan berikutnya
    start_of_next_month = (start_of_month + timedelta(days=32)).replace(day=1)

    # Filter data pembelian hanya untuk bulan ini
    purchases = Purchase.objects.filter(created_at__gte=start_of_month, created_at__lt=start_of_next_month)

    # Hitung jumlah pembelian per item
    purchase_counts = purchases.values('item__name').annotate(count=Count('item'))

    data = {'purchase_data': list(purchase_counts)}
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

    if request.user.employee.role == 'admin':
        purchases = Purchase.objects.filter(outlet_id=outlet_id).order_by('-created_at')
    else:
        purchases = Purchase.objects.order_by('-created_at')
    
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

    if request.user.employee.role == 'admin':
        sales = Sales.objects.filter(outlet_id=outlet_id).order_by('-created_at')
    else:
        sales = Sales.objects.order_by('-created_at')

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

# Periodic Review
def log_scaled_mutation(individual, mutation_rate, sigma=0.1, lower_bound=1, upper_bound=10000):
    """
    Applies log-scaled mutation to an individual while ensuring S > s.
    """
    mutated_individual = list(individual)  # Convert tuple to list for mutation
    
    for i, gene in enumerate(mutated_individual):
        if isinstance(gene, (int, float)):  # Ensure the gene is a number
            if random.random() < mutation_rate:
                # Apply log-scaled mutation
                r = random.gauss(0, sigma)  # Small random value from normal distribution
                mutated_gene = gene * (10 ** r)  # Logarithmic scaling
                # Clamp mutated value within bounds
                mutated_gene = max(min(mutated_gene, upper_bound), lower_bound)
                
                # Assign back the mutated value
                mutated_individual[i] = mutated_gene

    # Ensure S > s after mutation
    _, _, temp_R, temp_s, temp_S, purchases_freq, tot_lost = mutated_individual
    mutated_individual[4] = max(temp_s + 1, temp_S)  # Ensure S > s

    return tuple(mutated_individual)

def daily_demand(mean, sd, zero_threshold_factor=1.0):
    # Random threshold for zero demand (similar to the halton sequence effect)
    random_num = np.random.uniform(0, 1)
    
    # Probability of having zero demand (lower values result in more zeros)
    if random_num < zero_threshold_factor:
        return 0
    else:
        # Generate demand based on normal distribution
        return (max(0, np.random.normal(mean, sd)) * 2)

def simulate_inventory(product):
    product_sim = {}
    product_sim["nama_barang"] = product['nama_barang']
    product_sim["biaya_pesan"] = product['biaya_pesan']
    product_sim["permintaan_baku"] = product['permintaan_baku']
    product_sim["biaya_simpan"] = product['biaya_simpan']
    product_sim["biaya_kekurangan"] = product['biaya_kekurangan']
    product_sim["harga_produk"] = product['harga_produk']
    product_sim["lead_time"] = product['lead_time']
    product_sim["standar_deviasi"] = product['standar_deviasi']
    
    demand_list = []

    daily_mean = product["permintaan_baku"] / 180
    daily_sd = product["standar_deviasi"]  / np.sqrt(180)

    total_demand = 0

    for day in range(0, 180):
        day_demand = daily_demand(daily_mean, daily_sd, 0.5)

        if day_demand > 0:
            total_demand += day_demand
            demand_list.append(day_demand)
        else:
            demand_list.append(0)

    product_sim["permintaan_baku"] = round(total_demand)
    product_sim["standar_deviasi"] = np.std(demand_list)
    
    return product_sim, demand_list

# def genetic_algorithm(product_data, population_size, num_generations, crossover_rate, mutation_rate, daily_sales):
#     # Initialize population
#     population = []
#     for _ in range(population_size):
#         # product_sim, demand_result = simulate_inventory(product_data)

#         # return demand_result

#         # population.append((product_sim, demand_result))

#         total_cost, to = per_review(product_data, daily_sales)

#         R_min, s_min, S_min = find_rss(to, product_data)
#         init_R = round(R_min)
#         init_s = round(s_min)
#         init_S = round(S_min)

#         R_variation = 10
#         s_variation = 10000
#         rand_R = random.randint(init_R - R_variation, init_R + R_variation)
#         rand_s = random.randint(init_s - s_variation, init_s + s_variation)
#         rand_S = random.randint(init_S - s_variation, init_S + s_variation)
        
#         # population.append((product_data, daily_sales))
#         population.append((product_data, daily_sales, rand_R, rand_s, rand_S))

#     # Capture the first individual
#     # first_product_sim, first_demand_result = population[0]
#     first_product_sim = product_data
#     first_demand_result = daily_sales
#     first_total_cost, first_to = per_review(first_product_sim, first_demand_result)

#     total_biaya_penyimpanan_list = []
#     to_penyimpanan_list = []
#     data_list = []
#     demand_result_list = []
#     orders_lost_list = []

#     for generation in range(1, num_generations):
#         # Evaluate fitness of each individual
#         fitness_scores = []
#         for individual in population:
#             # product_sim, demand_result = individual
#             product_sim, demand_result, init_R, init_s, init_S = individual

#             # Simulate inventory and calculate total cost
#             total_cost, to = per_review(product_sim, demand_result)

#             total_biaya_penyimpanan_list.append(total_cost)
#             to_penyimpanan_list.append(to)
#             data_list.append(product_data)
#             demand_result_list.append(demand_result)

#             inventory_level_list, tot_dmd, tot_lost, max_inventory, purchases_freq, purchases_total, restock_data = calculate_inventory_levels_rss(demand_result, init_R, init_s, init_S)
#             # inventory_level_list, tot_dmd, tot_lost, max_inventory, purchases = calculate_inventory_levels(demand_result)

#             total_demand = sum(tot_dmd)
#             unsold_orders = sum(tot_lost)

#             # Fitness score
#             # fitness_score = total_cost
#             fitness_score = 0.5 * total_cost + 0.5 * (unsold_orders / total_demand if total_demand > 0 else unsold_orders)
#             # fitness_score = 0.5 * total_cost + 0.5 * unsold_orders

#             fitness_scores.append(fitness_score)  # Higher fitness for lower cost

#         # Selection (e.g., roulette wheel selection)
#         parents = []
#         for _ in range(population_size // 2):
#             parent1 = random.choices(population, weights=fitness_scores)[0]
#             parent2 = random.choices(population, weights=fitness_scores)[0]

#         parents.append((parent1, parent2))

#         # Crossover (RCM - Random Cross Mapping)
#         offspring = []
#         for parent1, parent2 in parents:
#             if random.random() < crossover_rate:
#                 mapping = [random.randint(0, 1) for _ in range(len(parent1))]
#                 child1 = tuple(parent1[i] if mapping[i] == 0 else parent2[i] for i in range(len(parent1)))
#                 child2 = tuple(parent2[i] if mapping[i] == 0 else parent1[i] for i in range(len(parent2)))
#             else:
#                 child1 = parent1
#                 child2 = parent2

#             offspring.append(child1)
#             offspring.append(child2)

#         # Mutation (Log-Scaled Mutation)
#         for i in range(len(offspring)):
#             offspring[i] = log_scaled_mutation(offspring[i], mutation_rate=mutation_rate)

#         population = offspring

#     # Select the best solution and corresponding simulation results
#     best_solution = min(population, key=lambda x: min_fitness(*x))
#     # best_solution = min(population, key=lambda x: 0.3 * min_fitness(*x)[0] + 0.7 * min_fitness(*x)[1])
#     best_product, best_demand, R_min, s_min, S_min = best_solution
#     # best_product, best_demand = best_solution

#     best_total_cost, best_to = per_review(best_product, best_demand)

#     # Finding first R, s, S based on the first `to`
#     first_R_min, first_s_min, first_S_min = find_rss(first_to, first_product_sim)
#     first_R = round(first_R_min)
#     first_s = round(first_s_min)
#     first_S = round(first_S_min)
#     first_half_demand = first_demand_result[:180]

#     # Finding best R, s, S
#     # R_min, s_min, S_min = find_rss(best_to, best_product)
#     best_R = round(R_min)
#     best_s = round(s_min)
#     best_S = round(S_min)
#     half_best_demand = best_demand[:180]

#     # Calculating first order lost
#     first_inventory_level_list, first_tot_dmd, first_tot_lost, first_max_inventory, first_purchases_freq, first_purchases_total, first_restock_data = calculate_inventory_levels_rss(first_half_demand, first_R, first_s, first_S)

#     # return best_R, best_s, best_S

#     # Calculating order lost
#     inventory_level_list, tot_dmd, tot_lost, max_inventory, purchases_freq, purchases_total, restock_data = calculate_inventory_levels_rss(half_best_demand, best_R, best_s, best_S)
    
#     total_demand = sum(tot_dmd)
#     unsold_orders = sum(tot_lost) / 6
#     # orders_lost_list.append(unsold_orders/total_demand)
#     orders_lost_list.append(unsold_orders)

#     # return unsold_orders

#     return total_biaya_penyimpanan_list, to_penyimpanan_list, data_list, demand_result_list, orders_lost_list, inventory_level_list, tot_dmd, tot_lost, max_inventory, purchases_freq, purchases_total, restock_data, best_product, best_demand, best_total_cost, best_to, best_R, best_s, best_S, first_R, first_s, first_S, first_purchases_freq, first_tot_lost, first_demand_result, first_purchases_total, first_inventory_level_list, first_restock_data

import random

def genetic_algorithm(product_data, population_size, num_generations, crossover_rate, mutation_rate, daily_sales):
    # Initialize population
    population = []

    # first_product, first_demand, first_R, first_s, first_S = population[0]

    first_tot_cost, first_to = per_review(product_data, daily_sales)
    first_R_min, first_s_min, first_S_min = find_rss(first_to, product_data)
    first_R, first_s, first_S = round(first_R_min), round(first_s_min), round(first_S_min)
    first_product = product_data
    first_demand = daily_sales

    for _ in range(population_size):
        total_cost, to = per_review(product_data, daily_sales)
        # R_min, s_min, S_min = find_rss(to, product_data)
        # init_R, init_s, init_S = round(R_min), round(s_min), round(S_min)
        
        variation = 20
        stock_variation = 10000
        rand_R = random.randint(first_R - variation, first_R + variation)
        rand_s = random.randint(max(2, first_s - stock_variation), first_s + stock_variation)
        rand_S = random.randint(max(rand_s + 1, first_S), first_S + stock_variation)
        rand_T = random.choice([90, 120, 150, 180])

        pop_inventory_level_list, _, pop_tot_lost, _, pop_purchases_freq, pop_purchases_total, pop_restock_data = calculate_inventory_levels_rss(daily_sales[:180], rand_R, rand_s, rand_S)
        
        # population.append((product_data, daily_sales, rand_R, rand_s, rand_S))
        population.append((product_data, daily_sales, rand_R, rand_s, rand_S, pop_purchases_freq, pop_tot_lost))
    
    first_inventory_level_list, _, first_tot_lost, _, first_purchases_freq, first_purchases_total, first_restock_data = calculate_inventory_levels_rss(first_demand[:180], first_R, first_s, first_S)
    first_total_cost, first_to = min_fitness(first_product, first_demand, first_R, first_s, first_S, first_purchases_freq, first_tot_lost)
    
    for generation in range(num_generations):
        fitness_scores = []
        for individual in population:
            product_sim, demand_result, init_R, init_s, init_S, init_purchases_freq, init_tot_lost = individual
            total_cost, total_stockout = min_fitness(product_sim, demand_result, init_R, init_s, init_S, init_purchases_freq, init_tot_lost)
            fitness_scores.append((total_cost, total_stockout))
        
        best_solution = min(zip(population, fitness_scores), key=lambda x: (x[1][0], x[1][1]))[0]
        
        # Selection (Roulette Wheel Selection)
        parents = []
        for _ in range(population_size // 2):
            parent1 = random.choices(population, weights=[1 / (1 + c + s) for c, s in fitness_scores])[0]
            parent2 = random.choices(population, weights=[1 / (1 + c + s) for c, s in fitness_scores])[0]
            parents.append((parent1, parent2))
        
        # Crossover (Random Cross Mapping)
        offspring = []
        for parent1, parent2 in parents:
            if random.random() < crossover_rate:
                mapping = [random.randint(0, 1) for _ in range(len(parent1))]
                child1 = tuple(parent1[i] if mapping[i] == 0 else parent2[i] for i in range(len(parent1)))
                child2 = tuple(parent2[i] if mapping[i] == 0 else parent1[i] for i in range(len(parent2)))
            else:
                child1, child2 = parent1, parent2

            def fix_S_s(individual):
                prod, demand, R, s, S, purchases_freq, tot_lost = individual
                S = max(s + 1, S)
                return (prod, demand, R, s, S, purchases_freq, tot_lost)

            child1 = fix_S_s(child1)
            child2 = fix_S_s(child2)

            offspring.extend([child1, child2])
        
        # Mutation (Log Scaled Mutation)
        for i in range(len(offspring)):
            offspring[i] = log_scaled_mutation(offspring[i], mutation_rate)
        
        population = offspring
    
    best_product, best_demand, best_R, best_s, best_S, best_purchases_freq, best_tot_lost = best_solution
    best_total_cost, best_to = min_fitness(best_product, best_demand, best_R, best_s, best_S, best_purchases_freq, best_tot_lost)

    best_R = round(best_R)
    best_s = round(best_s)
    best_S = round(best_S)
    
    inventory_level_list, tot_dmd, tot_lost, max_inventory, purchases_freq, purchases_total, restock_data = calculate_inventory_levels_rss(best_demand[:180], best_R, best_s, best_S)
    
    total_biaya_penyimpanan_list, to_penyimpanan_list, data_list, demand_result_list, orders_lost_list = [], [], [], [], []
    
    return (total_biaya_penyimpanan_list, to_penyimpanan_list, data_list, demand_result_list, orders_lost_list, 
            inventory_level_list, tot_dmd, best_tot_lost, max_inventory, best_purchases_freq, purchases_total, restock_data,
            best_product, best_demand, best_total_cost, best_to, best_R, best_s, best_S, 
            first_R, first_s, first_S, first_purchases_freq, first_tot_lost, first_demand, first_purchases_total,
            first_inventory_level_list, first_restock_data)

# Periodic Review Function
def per_review(product, demand):
    # Mencari review interval
    to = math.sqrt((2 * product["biaya_pesan"]) / (product["permintaan_baku"] * product["biaya_simpan"]))

    # Calculate alpha and reorder point (R)
    alpha = to * product["biaya_simpan"] / product["biaya_kekurangan"]
    z_alpha = ((NormalDist().inv_cdf(alpha) * -1))

    fz_alpha = (norm.pdf(2.22 , loc = 0 , scale = 1 ))
    wz_alpha = ((fz_alpha - 0.00001))

    R = ((product["permintaan_baku"] * to) + (product["permintaan_baku"] * product["lead_time"]) + (z_alpha * (math.sqrt(to + product["lead_time"]))))

    N = math.ceil(product["standar_deviasi"] * ((math.sqrt(to + product["lead_time"])) * ((fz_alpha - (z_alpha * wz_alpha)) * -1)))

    T = (product["permintaan_baku"] * product["harga_produk"]) + (product["biaya_pesan"] / to) + (product["biaya_simpan"] * (R - (product["permintaan_baku"] * product["lead_time"]) + (product["permintaan_baku"] * to / 2))) + (product["biaya_kekurangan"] / to * N)

    return T, to

# Periodic Review Function
def min_fitness(product, demand, init_R, init_s, init_S, purchases_freq, tot_lost):
    half_demand = demand[:180]

    if purchases_freq <= 0:
        purchases_freq = 1

    tot_demand = round(sum(half_demand))

    mean_daily_demand = np.mean(half_demand)
    std_dev_monthly_demand = np.std(half_demand, ddof=1)
    std_dev_daily_demand = std_dev_monthly_demand / np.sqrt(180)
    total_daily_demand = round(sum(half_demand) / 180)

    # Cost Calculation
    c_order = 35000 * (180 / (purchases_freq * init_R))
    c_hold = product["biaya_simpan"] * round((init_S + init_s) / 2) + round((tot_demand * init_R) / purchases_freq)
    
    total_stockout = round(sum(tot_lost))

    def integrand(x):
        demand_pdf = norm.pdf(x, mean_daily_demand, std_dev_daily_demand)
        return (x - total_daily_demand) * demand_pdf

    E_Rv, error = quad(integrand, total_daily_demand, np.inf)
    c_stockout = product["biaya_kekurangan"] * E_Rv

    c_total = c_order + c_hold + c_stockout

    return c_total, total_stockout

def find_rss(to, product):
    r = product["biaya_simpan"]

    # Hitung nilai alpha dan R
    alpha = to * r / product["biaya_kekurangan"]
    z_alpha = ((NormalDist().inv_cdf(alpha) * -1))

    fz_alpha = (norm.pdf(2.22 , loc = 0 , scale = 1 ))
    # wz_alpha = fz_alpha - (z_alpha * (1 - fz_alpha))
    wz_alpha = ((fz_alpha - 0.00001))

    R = ((product["permintaan_baku"] * to) + (product["permintaan_baku"] * product["lead_time"]) + (z_alpha * (math.sqrt(to + product["lead_time"]))))

    # Hitung total biaya total persediaan
    N = math.ceil(product["standar_deviasi"] * ((math.sqrt(to + product["lead_time"])) * ((fz_alpha - (z_alpha * wz_alpha)) * -1)))

    T = (product["permintaan_baku"] * product["harga_produk"]) + (product["biaya_pesan"] / to) + (r * (R - (product["permintaan_baku"] * product["lead_time"]) + (product["permintaan_baku"] * to / 2))) + (product["biaya_kekurangan"] / to * N)

    # Hitung nilai XR, XRL, dan sigma_RL
    XR = to * product["permintaan_baku"]
    XRL = (to + product["lead_time"]) * product["permintaan_baku"]
    sigma_RL = (to + product["lead_time"]) * product["standar_deviasi"]

    Qp = (1.3 * (XR ** 0.494) * ((product["biaya_pesan"] / r) ** 0.506) * ((1 + ((sigma_RL ** 2) / (XR ** 2))) ** 0.116))
    z = math.sqrt((Qp * r) / (sigma_RL * product["biaya_kekurangan"]))

    Sp = ((0.973 * XRL) + (sigma_RL * ((0.183 / z) + 1.063 - (2.192 * z))))

    k = (r / (r + product["biaya_kekurangan"]))

    So = (XRL + (k * sigma_RL))

    S_list = [(Sp + Qp), (So)]
    
    R_to = (to * 1000)
    s = (Sp)
    S = max(S_list)

    return R_to, s, S

# Calculate the inventory levels
def calculate_inventory_cost(product_list, to_list):
    inventory_cost_list = []

    for x, product in enumerate(product_list):
        A = product["biaya_pesan"]
        D = product["permintaan_baku"] / 6
        vr = product["biaya_simpan"]
        B3 = product["biaya_kekurangan"]
        L = product["lead_time"]
        Std = product["standar_deviasi"]
        k = round(vr / (vr + B3), 2)
        sigma_RL = (to_list[x] + L) * Std

        Q = math.sqrt((2 * A * D) / vr)

        biaya_pesan = (A * D) / Q
        biaya_simpan = ((Q / 2) + (k * sigma_RL) * vr)
        biaya_kekurangan = (B3 * sigma_RL * 0.216 * D) / Q

        ongkos_total = biaya_pesan + biaya_simpan + biaya_kekurangan
        inventory_cost_list.append(ongkos_total)
    
    return inventory_cost_list

# Calculate the inventory level and lost orders
def calculate_inventory_levels(demand_result):
    inventory_level = []
    units_lost_list = []
    total_demand_list = []

    inventory = 3000
    review_period = 30
    lead_time = 7
    max_inventory = 3000

    stock = 0
    stockout = 0
    counter = 0
    purchases_freq = 0
    purchases_total = 0
    order_placed = False

    for day, x in enumerate(demand_result):
        if day % review_period == 0:
            if not order_placed:
                # Placing the order
                order_placed = True
                counter = 0
                q = max_inventory - inventory

        if order_placed:
            counter += 1
            purchases_freq += 1

        if counter == lead_time:
            # Restocking day
            inventory += q
            purchases_total += q
            order_placed = False
            counter = 0

        if inventory - x >= 0:
            inventory -= x
            stock_out = 0
        elif inventory - x < 0:
            inventory = 0
            stockout += x
            stock_out = x
        
        inventory_level.append(inventory)
        total_demand_list.append(x)
        units_lost_list.append(stock_out)

    return inventory_level, total_demand_list, units_lost_list, max_inventory, purchases_freq

def calculate_inventory_levels_rss(demand_result, R, s, S):
    inventory_level = []
    units_lost_list = []
    total_demand_list = []
    restock_array = []

    inventory = S
    review_period = R
    lead_time = 7
    max_inventory = S

    stockout = 0
    counter = 0
    purchases_freq = 0
    purchases_total = 0
    order_placed = False

    for day, x in enumerate(demand_result):
        if day % review_period == 0:
            if inventory < s and not order_placed:
                # Placing the order
                order_placed = True
                counter = 0

        if order_placed:
            counter += 1

        if counter == lead_time:
            # Restocking day
            purchases_total += max_inventory - inventory
            restock_array.append(max_inventory - inventory)
            inventory = max_inventory
            order_placed = False
            counter = 0
            purchases_freq += 1
        else:
            restock_array.append(0)

        if inventory - x >= 0:
            inventory -= x
            stock_out = 0
        elif inventory - x < 0:
            inventory = 0
            stockout += x
            stock_out = x
        
        inventory_level.append(inventory)
        total_demand_list.append(x)
        units_lost_list.append(stock_out)

    return inventory_level, total_demand_list, units_lost_list, max_inventory, purchases_freq, purchases_total, restock_array

def calculate_inventory_levels_vendor(demand_data, restock_data):
    inventory_level = []
    units_lost_list = []
    total_demand_list = []

    inventory = 5000
    review_period = 30
    lead_time = 7
    max_inventory = 5000

    stock = 0
    stockout = 0
    counter = 0
    purchases_freq = 0
    purchases_total = 0
    order_placed = False

    for day, x in enumerate(demand_data):
        if inventory - x >= 0:
            inventory -= x
            stock_out = 0
        elif inventory - x < 0:
            inventory = 0
            stockout += x
            stock_out = x
        
        inventory_level.append(inventory)
        total_demand_list.append(x)
        units_lost_list.append(stock_out)

    return inventory_level, total_demand_list, units_lost_list, max_inventory, purchases_freq

# Periodic Review
@login_required
def periodic_view(request):
    if request.method == 'POST':
        array = []
        data = []

        try:
            user_id = request.user.id
            outlet_id = request.user.employee.outlet_id
            # return HttpResponse(outlet_id)
            array = []
            
            # Fetch items and sales data directly from the database
            items = Item.objects.filter(type="JADI")

            for item in items:
                if request.user.employee.role == 'superadmin':
                    sales = Sales.objects.filter(item_id=item.id)
                else:
                    sales = Sales.objects.filter(outlet_id=outlet_id, item_id=item.id)
                sales_list = [sale.amount for sale in sales]
                
                # Calculate total sales and standard deviation
                total_sales = sum(sales_list)
                standar_deviasi = np.std(sales_list) if len(sales_list) > 1 else (sales_list[0] if sales_list else 1)

                # Prepare data for periodic review processing
                array_data = {
                    'nama_barang': item.name,
                    'biaya_pesan': item.biaya_pesan,
                    'permintaan_baku': total_sales,
                    'biaya_simpan': 2000,
                    'biaya_kekurangan': round((item.price * 7.5 / 100) + item.price),
                    'harga_produk': item.price,
                    'lead_time': item.lead_time / 100,  # Adjusted for percentage
                    'standar_deviasi': standar_deviasi,
                }

                array.append(array_data)
        except Exception as e:
            messages.error(request, f"An error occurred: {str(e)}")
            return redirect(request.META.get('HTTP_REFERER', '/'))
                
        # define var
        pop_size = int(request.POST['population_size'])
        num_generations = int(request.POST['num_generations'])
        crossover_rate = float(request.POST['crossover_rate'])
        mutation_rate = float(request.POST['mutation_rate'])

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
            
            tp_list, to_list, data_list, demand_result_list, orders_lost_list, inventory_level_list, total_demand, total_lost, max_inventory, purchases_freq, purchases_total, restock_data, best_product, best_demand, best_total_cost, best_to, best_R, best_s, best_S, first_R, first_s, first_S, first_purchases_freq, first_total_lost, first_demand, first_purchases_total, first_inventory_level_list, first_restock_data = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)
            # pop, fit_score, pop_size = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

            # best_demand = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

            # temp = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

            # return HttpResponse(product['permintaan_baku'])

            # # Join the list items with commas
            # data_string = ', '.join(str(item) for item in temp)
            
            # # Return the string in an HttpResponse
            # return HttpResponse(data_string)

            # return HttpResponse(sum(total_demand))
            
            # grafik orders lost
            f_lost = plt.figure(figsize=(6, 4))
            gs = f_lost.add_gridspec(1, 1)
            ax = f_lost.add_subplot(gs[0, 0])
            sns.distplot(orders_lost_list,kde=False, color = "#097969")
            ax.set_title(f'Lost Order : Mean {np.mean(orders_lost_list):.3f}')
            ax.axvline(x = np.mean(orders_lost_list), color='k', alpha = .5, ls = '--')
            plt.tight_layout()
            flike = io.BytesIO()
            f_lost.savefig(flike)
            simulation_lost_plot = base64.b64encode(flike.getvalue()).decode()
            # plt.hist(orders_lost_list)
            # plt.xlabel('Orders Lost')
            # plt.ylabel('Frequency')

            # flike = io.BytesIO()
            # plt.savefig(flike)
            # simulation_lost_plot = base64.b64encode(flike.getvalue()).decode()
            # plt.switch_backend('agg')
            plt.close()

            # grafik biaya inventory
            # plt.hist(tp_list)
            inventory_cost_list = calculate_inventory_cost(data_list, to_list)
            plt.figure(figsize=(6, 4))
            plt.hist(inventory_cost_list, color = "#097969")
            plt.xlabel('Inventory Cost')
            plt.ylabel('Frequency')

            formatter = FuncFormatter(lambda x, _: f'{int(x):,}')
            plt.gca().xaxis.set_major_formatter(formatter)
            plt.xticks(rotation=45)
            plt.tight_layout()

            flike = io.BytesIO()
            plt.savefig(flike)
            biaya_inventory_plot = base64.b64encode(flike.getvalue()).decode()
            plt.switch_backend('agg')
            plt.close()

            # return HttpResponse(z)

            # grafik demand
            demand_result_filtered = [i for i in best_demand if i != 0]
            plt.figure(figsize=(6, 4))
            plt.hist(demand_result_filtered, color = "#097969")
            plt.xlabel('Demand')
            plt.ylabel('Frequency')
            plt.tight_layout()

            flike = io.BytesIO()
            plt.savefig(flike)
            demand_plot = base64.b64encode(flike.getvalue()).decode()
            plt.switch_backend('agg')
            plt.close()

            # return HttpResponse(', '.join(map(str, inventory_level_list)))

            # grafik inventory level
            fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18,6))
            plt.plot(inventory_level_list, linewidth = 1.5)
            plt.axhline(best_S, linewidth=2, color="grey", linestyle=":")
            plt.axhline(0, linewidth=2, color="grey", linestyle=":")
            plt.xlim(0,180)
            ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
            ax.set_xlabel('Day', fontsize=18)

            flike = io.BytesIO()
            plt.savefig(flike)
            inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
            plt.switch_backend('agg')
            plt.close()
            
            temp = {
                'nama_barang': product["nama_barang"],

                'R': round(best_R),
                's': round(best_s),
                'S': round(best_S),
                'order_lost': round(sum(total_lost) / 6),

                'biaya_inventory_min': round(min(inventory_cost_list)),
                'biaya_inventory_mean': round(np.mean(inventory_cost_list)),
                'biaya_inventory_std': round(np.std(inventory_cost_list)),

                'demand_plot': demand_plot,
                'biaya_inventory_plot': biaya_inventory_plot,
                'inventory_level_plot': inventory_level_plot,
                'simulation_lost_plot': simulation_lost_plot,

                'mc_result': best_product,
                'demand_result': best_demand,
                'biaya_penyimpanan': 0,
                'total_biaya_penyimpanan': round(best_to, 4),
            }

            data.append(temp)
                
        context = {
            'data': data,
        }

        return render(request, 'periodic/calculation.html', context)

    context = {
        'data': '',
    }

    return render(request, 'periodic/index.html', context)

# Periodic Review
@login_required
def inventory_collab_view(request):
    if request.method == 'POST':
        array = []
        data = []

        # Genetic Algorithm Calculation
        pop_size = int(request.POST['population_size'])
        num_generations = int(request.POST['num_generations'])
        crossover_rate = float(request.POST['crossover_rate'])
        mutation_rate = float(request.POST['mutation_rate'])

        # Outlets
        outlets = Outlet.objects.exclude(id=3)

        if request.user.employee.role == 'superadmin':
            # Initialize a dictionary to hold the aggregated total data
            total_data_dict = {}

            # Initialize a dictionary to store the outlet's combined inventory levels
            first_outlet_inventory_levels = {}
            outlet_inventory_levels = {}

            data_all = []
            for outlet in outlets:
                # outlet = outlets[0]
                data_outlet = []
                
                # Initialize an empty list to hold the combined inventory levels for this outlet
                first_combined_inventory_level = [0] * 180
                combined_inventory_level = [0] * 180

                # try:
                # Reset data for the current outlet
                data = []
                
                # Fetch items
                items = Item.objects.filter(type="JADI")
                
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

                    # Convert to a dictionary with date as key
                    sales_dict = {sale['created_at'].date(): sale['total_sales'] for sale in sales_data}

                    # Determine the date range (assuming you want the last 7 days)
                    start_date = min(sales_dict.keys(), default=datetime.today().date())
                    end_date = start_date + timedelta(days=179)

                    # Generate the daily sales array
                    daily_sales = []
                    current_date = start_date
                    while current_date <= end_date:
                        daily_sales.append(sales_dict.get(current_date, 0))  # Get sales or default to 0
                        current_date += timedelta(days=1)

                    # Prepare data for periodic review processing
                    product = {
                        'nama_barang': item.name,
                        'biaya_pesan': item.biaya_pesan,
                        'permintaan_baku': total_sales,
                        'biaya_simpan': 2000,  # Static value as per your example
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
                    best_total_cost, best_to, best_R, best_s, best_S, first_R, first_s, first_S, first_purchases_freq, first_total_lost, first_demand, first_purchases_total, first_inventory_level_list, first_restock_data) = genetic_algorithm(
                        product, pop_size, num_generations, crossover_rate, mutation_rate, daily_sales
                    )

                    # temp, temp2 = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate, daily_sales)

                    # temp_data = {
                    #     'purchases_freq': temp,
                    #     'tot_lost': temp2
                    # }

                    # return JsonResponse(temp_data)

                    # return HttpResponse(temp_R)
                    # return HttpResponse(', '.join(map(str, sales_list)))

                    # FIRST DATA
                    first_half_demand = first_demand[:180]
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
                    for i in range(180):
                        first_stock += round(first_restock_result[i])  # Add the value from array1
                        first_stock -= round(first_restock_data[i])  # Subtract the value from array2
                        first_stock_history.append(first_stock)  # Store the updated stock value

                    # Add the product's inventory level to the combined list (sum or average)
                    for day in range(min(180, len(first_inventory_level_list))):  # Limit to 180 days
                        first_combined_inventory_level[day] += first_inventory_level_list[day]

                    first_mean_daily_demand = np.mean(first_half_demand)
                    first_std_dev_monthly_demand = np.std(first_half_demand, ddof=1)
                    first_std_dev_daily_demand = first_std_dev_monthly_demand / np.sqrt(180)
                    first_total_daily_demand = round(sum(first_half_demand) / 180)

                    # Plotting inventory level for outlet
                    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                    plt.plot(first_inventory_level_list, linewidth=1.5)
                    plt.axhline(first_S, linewidth=2, color="grey", linestyle=":")
                    plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                    plt.xlim(0, 180)
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
                    first_c_order = 35000 * (180 / (first_purchases_freq * first_R))

                    # Calculate biaya simpan
                    first_c_hold = product["biaya_simpan"] * ((first_S + first_s) / 2) + ((first_total_demand * first_R) / first_purchases_freq)
                    
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
                    # END FIRST DATA

                    # BEST DATA
                    half_demand = best_demand[:180]
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
                    for i in range(180):
                        stock += round(restock_result[i])  # Add the value from array1
                        stock -= round(restock_data[i])  # Subtract the value from array2
                        stock_history.append(stock)  # Store the updated stock value

                    # return HttpResponse(', '.join(map(str, restock_data)))
                    # return HttpResponse(restock_data)

                    # Add the product's inventory level to the combined list (sum or average)
                    for day in range(min(180, len(inventory_level_list))):  # Limit to 180 days
                        combined_inventory_level[day] += inventory_level_list[day]

                    mean_daily_demand = np.mean(half_demand)
                    std_dev_monthly_demand = np.std(half_demand, ddof=1)
                    std_dev_daily_demand = std_dev_monthly_demand / np.sqrt(180)
                    total_daily_demand = round(sum(half_demand) / 180)

                    # Plotting inventory level for outlet
                    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                    plt.plot(inventory_level_list, linewidth=1.5)
                    plt.axhline(best_S, linewidth=2, color="grey", linestyle=":")
                    plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                    plt.xlim(0, 180)
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
                    c_order = 35000 * (180 / (purchases_freq * best_R))
                    c_hold = product["biaya_simpan"] * round((best_S + best_s) / 2) + round((tot_demand * best_R) / purchases_freq)
                    
                    total_stockout = round(sum(total_lost))

                    def integrand(x):
                        demand_pdf = norm.pdf(x, mean_daily_demand, std_dev_daily_demand)
                        return (x - total_daily_demand) * demand_pdf

                    E_Rv, error = quad(integrand, total_daily_demand, np.inf)
                    c_stockout = product["biaya_kekurangan"] * E_Rv

                    c_total = c_order + c_hold + c_stockout
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
                        'c_order': round(c_order),
                        'c_hold': round(c_hold),
                        'c_stockout': round(c_stockout),
                        'c_total': round(c_total),
                        'purchases_freq': round(purchases_freq),
                        'purchases_total': round(purchases_total),
                        'stockout_total': round(total_stockout),
                        'stockout_mean': total_stockout,
                        'restock_data': [a - b for a, b in zip(half_demand, restock_data)],
                        'stock_history': stock_history
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
                        'first_inventory_level_plot': first_inventory_level_plot,
                        'c_order': round(c_order),
                        'c_hold': round(c_hold),
                        'c_stockout': round(c_stockout),
                        'c_total': round(c_total),
                        'purchases_freq': round(purchases_freq),
                        'purchases_total': round(purchases_total),
                        'stockout_total': round(total_stockout),
                        'stockout_mean': total_stockout,
                        'inventory_level_plot': inventory_level_plot,
                    })
                    # except Exception as e:
                    #     messages.error(request, f"Error in genetic algorithm: {str(e)}")
                    #     continue

                # FIRST DATA
                # After processing all products for this outlet, generate the plot
                fig, ax = plt.subplots(figsize=(18, 6))
                ax.plot(first_combined_inventory_level, linewidth=1.5)
                ax.set_xlim(0, 180)  # Ensure it stays within 180 days
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
                ax.set_xlim(0, 180)  # Ensure it stays within 180 days
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

                # BEST DATA
                total_order = sum(item['c_order'] for item in data)
                total_hold = sum(item['c_hold'] for item in data)
                total_stockout = sum(item['c_stockout'] for item in data)
                total_all = sum(item['c_total'] for item in data)
                total_purchases_freq = sum(item['purchases_freq'] for item in data)
                total_purchases_total = sum(item['purchases_total'] for item in data)
                total_stockout_total = sum(item['stockout_total'] for item in data)
                
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
                    'total_order': total_order,
                    'total_hold': total_hold,
                    'total_stockout': total_stockout,
                    'total_all': total_all,
                    'total_purchases_freq': total_purchases_freq,
                    'total_purchases_total': total_purchases_total,
                    'total_stockout_total': total_stockout_total,
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
                first_stock_history_month = dt['first_stock_history'][:180]
                first_stockout_mean = dt['first_stockout_mean']

                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                plt.plot(first_stock_history_month, linewidth=1.5)
                # plt.axhline(5000, linewidth=2, color="grey", linestyle=":")
                # plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0, 180)
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
                ax.set_title(f'Lost Order : Mean {np.mean(first_stockout_mean):.3f}')
                ax.axvline(x = np.mean(first_stockout_mean), color='k', alpha = .5, ls = '--')
                plt.tight_layout()
                flike = io.BytesIO()
                f_lost.savefig(flike)
                dt['first_lost_order_plot'] = base64.b64encode(flike.getvalue()).decode()
                plt.close()

                # BEST DATA
                # Plotting inventory level for vendor
                stock_history_month = dt['stock_history'][:180]
                stockout_mean = dt['stockout_mean']

                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18, 6))
                plt.plot(stock_history_month, linewidth=1.5)
                # plt.axhline(5000, linewidth=2, color="grey", linestyle=":")
                # plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0, 180)
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
                ax.set_title(f'Lost Order : Mean {np.mean(stockout_mean):.3f}')
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
            first_total_purchases_freq = sum(item['first_purchases_freq'] for item in total_data)
            first_total_purchases_total = sum(item['first_purchases_total'] for item in total_data)
            first_total_stockout_total = sum(item['first_stockout_total'] for item in total_data)

            # BEST DATA
            total_order = sum(item['c_order'] for item in total_data)
            total_hold = sum(item['c_hold'] for item in total_data)
            total_stockout = sum(item['c_stockout'] for item in total_data)
            total_all = sum(item['c_total'] for item in total_data)
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
                'first_total_purchases_freq': first_total_purchases_freq,
                'first_total_purchases_total': first_total_purchases_total,
                'first_total_stockout_total': first_total_stockout_total,
                'total_order': total_order,
                'total_hold': total_hold,
                'total_stockout': total_stockout,
                'total_all': total_all,
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
                
                tp_list, to_list, data_list, demand_result_list, orders_lost_list, inventory_level_list, total_demand, total_lost, max_inventory, purchases_freq, purchases_total, best_product, best_demand, best_total_cost, best_to, best_R, best_s, best_S, first_R, first_s, first_S, first_purchases_freq, first_total_lost, first_demand, first_purchases_total, first_inventory_level_list, first_restock_data = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

                # FIRST DATA
                first_half_demand = first_demand[:180]
                first_total_demand = round(sum(first_half_demand))
                
                first_mean_daily_demand = np.mean(first_half_demand)
                first_std_dev_monthly_demand = np.std(first_half_demand, ddof=1)
                first_std_dev_daily_demand = first_std_dev_monthly_demand / np.sqrt(180)
                first_total_daily_demand = round(sum(first_half_demand) / 180)

                # BEST DATA
                half_demand = best_demand[:180]
                total_demand = round(sum(half_demand))
                
                mean_daily_demand = np.mean(half_demand)
                std_dev_monthly_demand = np.std(half_demand, ddof=1)
                std_dev_daily_demand = std_dev_monthly_demand / np.sqrt(180)
                total_daily_demand = round(sum(half_demand) / 180)

                # return HttpResponse(total_demand)

                # FIRST DATA
                # grafik inventory level
                fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18,6))
                plt.plot(first_inventory_level_list, linewidth = 1.5)
                plt.axhline(best_S, linewidth=2, color="grey", linestyle=":")
                plt.axhline(0, linewidth=2, color="grey", linestyle=":")
                plt.xlim(0,180)
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
                plt.xlim(0,180)
                ax.set_ylabel('Inventory Level (pcs)', fontsize=18)
                ax.set_xlabel('Day', fontsize=18)

                flike = io.BytesIO()
                plt.savefig(flike)
                inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
                plt.switch_backend('agg')
                plt.close()

                # FIRST DATA
                # Calculate biaya order
                first_c_order = 35000 * (180 / (first_purchases_freq * first_R))

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
                c_order = 35000 * (180 / (purchases_freq * best_R))

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

    return render(request, 'inventory_collab/index.html', context)