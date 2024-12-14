from __future__ import division

from django.shortcuts import render
from django.http import Http404
from django.contrib import messages
from django.shortcuts import redirect
from django.http import HttpResponse
from django.core import serializers
import json
from django.http import JsonResponse
from django.utils import timezone
from datetime import timedelta
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
# from decorators import anonymous_required
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.db.models import Q
from django.core.serializers import serialize

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
            return render(request, 'login.html', {'error': 'Username tidak ditemukan'})

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('dashboard')
        else:
            return render(request, 'auth/login.html', {'error': 'Password salah'})
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
            messages.success(request, 'Sukses Menambah Outlet baru.')
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
        raise Http404("Outlet tidak ditemukan.")
    # Mengecek method pada request
    # Jika method-nya adalah POST, maka akan dijalankan
    # proses validasi dan penyimpanan data
    if request.method == 'POST':
        form = OutletForm(request.POST, instance=outlet)
        if form.is_valid():
            # Simpan perubahan data ke dalam table outlets
            form.save()
            # mengeset pesan sukses dan redirect ke halaman daftar outlet
            messages.success(request, 'Sukses Mengubah Outlet.')
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
        messages.success(request, 'Sukses Menghapus Outlet.')
        return redirect('outlet.index')
    except Outlet.DoesNotExist:
        # Jika data outlet tidak ditemukan,
        # maka akan di redirect ke halaman 404 (Page not found).
        raise Http404("Outlet tidak ditemukan.")

def outlet_select_view(request, outlet_id):
    request.session['outlet_id'] = outlet_id

    if outlet_id == 'all':
        request.session['outlet_name'] = 'Semua Cabang'
    else:
        outlet = Outlet.objects.get(pk=outlet_id)
        request.session['outlet_name'] = outlet.name

    return HttpResponse(True)

def outlet_get_view(request):
    user_id         = request.user.id
    outlets = Outlet.objects.filter(user_id=user_id)
    data = serializers.serialize('json', outlets)
    
    return HttpResponse(data, content_type="text/json-comment-filtered")

# Material
@login_required
def material_view(request):
    user_id         = request.user.id
    materials = Material.objects.filter(user_id=user_id)
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
            messages.success(request, 'Sukses Menambah Material baru.')
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
            messages.success(request, 'Sukses Mengubah Item.')
            return redirect('material.index')
    else:
        form = MaterialForm(instance=material)
    return render(request, 'material/form.html', {'form': form})

def material_delete_view(request, material_id):
    try:
        material = Material.objects.get(pk=material_id)
        material.delete()
        messages.success(request, 'Sukses Menghapus Material.')
        return redirect('material.index')
    except Material.DoesNotExist:
        raise Http404("Material tidak ditemukan.")
    
# Product
@login_required
def product_view(request):
    user_id         = request.user.id
    items        = Item.objects.filter(type="JADI", user_id=user_id)
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
        # membuat objek dari class TaskForm
        form = ItemForm(request.POST, request.FILES)
        # Mengecek validasi form
        if form.is_valid():
             # Buat objek outlet baru dari form tanpa menyimpan ke database dulu
            new_outlet = form.save(commit=False)
            # Tambahkan user_id dari pengguna yang sedang terautentikasi
            new_outlet.user_id = user_id
            # Simpan objek outlet baru ke database
            new_outlet.save()
            # mengeset pesan sukses dan redirect ke halaman daftar task
            messages.success(request, 'Sukses Menambah Item baru.')
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
        form = ItemForm(request.POST, request.FILES, instance=item)
        if form.is_valid():
            form.save()
            messages.success(request, 'Sukses Mengubah Item.')
            return redirect('product.index')
    else:
        form = ItemForm(instance=item)
    return render(request, 'product/form.html', {'form': form})

def product_delete_view(request, product_id):
    try:
        item = Item.objects.get(pk=product_id)
        item.delete()
        messages.success(request, 'Sukses Menghapus Item.')
        return redirect('product.index')
    except Item.DoesNotExist:
        raise Http404("Item tidak ditemukan.")
    
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
            messages.success(request, 'Sukses Menambah Resep baru.')
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
        messages.success(request, 'Sukses Menghapus Resep.')
        return redirect('product.recipe.index', product_id)
    except Recipe.DoesNotExist:
        raise Http404("Resep tidak ditemukan.")

# Purchase
@login_required
def purchase_view(request):
    user_id         = request.user.id
    if request.session.has_key('outlet_id'):
        if request.session['outlet_id'] == 'all':
            purchases = Purchase.objects.filter(user_id=user_id).order_by('-created_at')
        else:
            purchases = Purchase.objects.filter(user_id=user_id).order_by('-created_at')
    else:
        purchases = Purchase.objects.filter(user_id=user_id)
    context = {
        'purchases': purchases
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

            messages.success(request, 'Sukses menambah pembelian baru.')
            return redirect('purchase.index')
    else:
        form = PurchaseForm()
    return render(request, 'purchase/form.html', {'form': form})

@login_required
def purchase_update_view(request, purchase_id):
    try:
        purchase = Purchase.objects.get(pk=purchase_id)
    except Purchase.DoesNotExist:
        raise Http404("Pembelian tidak ditemukan.")
    if request.method == 'POST':
        form = PurchaseForm(request.POST, instance=purchase)
        if form.is_valid():
            form.save()
            messages.success(request, 'Sukses Mengubah pembelian.')
            return redirect('purchase.index')
    else:
        form = PurchaseForm(instance=purchase)
    return render(request, 'purchase/form.html', {'form': form})

def purchase_delete_view(request, purchase_id):
    try:
        purchase = Purchase.objects.get(pk=purchase_id)
        purchase.delete()
        messages.success(request, 'Sukses menghapus pembelian.')
        return redirect('purchase.index')
    except Purchase.DoesNotExist:
        raise Http404("Pembelian tidak ditemukan.")

# Production
@login_required
def production_view(request):
    user_id         = request.user.id
    if request.session.has_key('outlet_id'):
        if request.session['outlet_id'] == 'all':
            productions = Production.objects.filter(user_id=user_id).order_by('-created_at')
        else:
            productions = Production.objects.objects.filter(user_id=user_id).order_by('-created_at')
    else:
        productions = Production.objects.filter(user_id=user_id)

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

            messages.success(request, 'Sukses menambah produksi baru.')
            return redirect('production.index')
    else:
        form = ProductionForm()
    return render(request, 'production/form.html', {'form': form})

def production_update_view(request, production_id):
    try:
        production = Production.objects.get(pk=production_id)
    except Production.DoesNotExist:
        raise Http404("Produksi tidak ditemukan.")
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
        messages.success(request, 'Sukses menghapus pembelian.')
        return redirect('production.index')
    except Production.DoesNotExist:
        raise Http404("Pembelian tidak ditemukan.")

# Sales
@login_required
def sales_view(request):
    user_id         = request.user.id
    if request.session.has_key('outlet_id'):
        if request.session['outlet_id'] == 'all':
            sales = Sales.objects.filter(user_id=user_id).order_by('-created_at')
        else:
            sales = Sales.objects.filter(user_id=user_id).order_by('-created_at')
    else:
        sales = Sales.objects.filter(user_id=user_id).order_by('-created_at')

    context = {
        'sales': sales
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

            messages.success(request, 'Sukses menambah penjualan baru.')
            return redirect('sales.index')
    else:
        form = SalesForm()
    return render(request, 'sales/form.html', {'form': form})

@login_required
def sales_update_view(request, sales_id):
    try:
        sales = Sales.objects.get(pk=sales_id)
    except Sales.DoesNotExist:
        raise Http404("Penjualan tidak ditemukan.")
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

            messages.success(request, 'Sukses Mengubah penjualan.')
            return redirect('sales.index')
    else:
        form = SalesForm(instance=sales)
    return render(request, 'sales/form.html', {'form': form})

def sales_delete_view(request, sales_id):
    try:
        sales = Sales.objects.get(pk=sales_id)
        sales.delete()
        messages.success(request, 'Sukses menghapus penjualan.')
        return redirect('sales.index')
    except Sales.DoesNotExist:
        raise Http404("Penjualan tidak ditemukan.")

# Transaction
@login_required
def transaction_view(request):
    user_id         = request.user.id
    if request.session.has_key('outlet_id'):
        if request.session['outlet_id'] == 'all':
            transactions = Transaction.objects.filter(user_id=user_id).order_by('-created_at')
        else:
            transactions = Transaction.objects.filter(user_id=user_id).order_by('-created_at')
    else:
        transactions = Transaction.objects.filter(user_id=user_id).order_by('-created_at')
    
    context = {
        'transactions': transactions
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
            row = [idx+1, item.name, item.biaya_pesan, sales_count, 50000, biaya_kekurangan, item.price, item.lead_time, standar_deviasi]
            writer.writerow(row)
        return response
    
    context = {
        # 'transactions': transactions
    }

    return render(request, 'export/index.html', context)

# Periodic Review
def log_scaled_mutation(individual, mutation_rate, sigma=0.1, lower_bound=1, upper_bound=100):
    """
    Applies log-scaled mutation to an individual.
    """
    mutated_individual = []
    for gene in individual:
        if isinstance(gene, (int, float)):  # Ensure the gene is a number
            if random.random() < mutation_rate:
                # Apply log-scaled mutation
                r = random.gauss(0, sigma)  # Small random value from normal distribution
                mutated_gene = gene * (10 ** r)  # Logarithmic scaling
                # Clamp mutated value within bounds
                mutated_gene = max(min(mutated_gene, upper_bound), lower_bound)
                mutated_individual.append(mutated_gene)
            else:
                mutated_individual.append(gene)
        else:
            # Keep non-numerical genes unchanged
            mutated_individual.append(gene)
    return tuple(mutated_individual)

def daily_demand(mean, sd, zero_threshold_factor=1.0):
    # Random threshold for zero demand (similar to the halton sequence effect)
    random_num = np.random.uniform(0, 1)
    
    # Probability of having zero demand (lower values result in more zeros)
    if random_num < zero_threshold_factor:
        return 0
    else:
        # Generate demand based on normal distribution
        return max(0, np.random.normal(mean, sd))

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

    mean = product["permintaan_baku"] / 180
    sd = product["standar_deviasi"] / np.sqrt(180)

    total_demand = 0

    for day in range(1, 365):
        day_demand = daily_demand(mean, sd, 0.65)

        if day_demand > 0:
            total_demand += day_demand
            demand_list.append(day_demand)
        else:
            demand_list.append(0)

    product_sim["permintaan_baku"] = round(total_demand)
    product_sim["standar_deviasi"] = np.std(demand_list)
    
    return product_sim, demand_list

def genetic_algorithm(product_data, population_size, num_generations, crossover_rate, mutation_rate):
    # Initialize population
    population = []
    for _ in range(population_size):
        product_sim, demand_result = simulate_inventory(product_data)
        population.append((product_sim, demand_result))

    total_biaya_penyimpanan_list = []
    to_penyimpanan_list = []
    data_list = []
    demand_result_list = []
    orders_lost_list = []

    for generation in range(1, num_generations):
        # Evaluate fitness of each individual
        fitness_scores = []
        for individual in population:
            product_sim, demand_result = individual

            # Simulate inventory and calculate total cost
            total_cost, to = per_review(product_sim, demand_result)

            total_biaya_penyimpanan_list.append(total_cost)
            to_penyimpanan_list.append(to)
            data_list.append(product_sim)
            demand_result_list.append(demand_result)

            inventory_level_list, tot_dmd, tot_lost, max_inventory = calculate_inventory_levels(demand_result)

            total_demand = sum(tot_dmd)
            unsold_orders = sum(tot_lost)

            # Fitness score
            fitness_score = 0.5 * total_cost + 0.5 * (unsold_orders / total_demand if total_demand > 0 else 0)
            # fitness_score = 0.5 * total_cost + 0.5 * unsold_orders

            fitness_scores.append(fitness_score)  # Higher fitness for lower cost

        # Selection (e.g., roulette wheel selection)
        parents = []
        for _ in range(population_size // 2):
            parent1 = random.choices(population, weights=fitness_scores)[0]
            parent2 = random.choices(population, weights=fitness_scores)[0]

        parents.append((parent1, parent2))

        # Crossover (RCM - Random Cross Mapping)
        offspring = []
        for parent1, parent2 in parents:
            if random.random() < crossover_rate:
                mapping = [random.randint(0, 1) for _ in range(len(parent1))]
                child1 = tuple(parent1[i] if mapping[i] == 0 else parent2[i] for i in range(len(parent1)))
                child2 = tuple(parent2[i] if mapping[i] == 0 else parent1[i] for i in range(len(parent2)))
            else:
                child1 = parent1
                child2 = parent2

            offspring.append(child1)
            offspring.append(child2)

        # Mutation (Log-Scaled Mutation)
        for i in range(len(offspring)):
            offspring[i] = log_scaled_mutation(offspring[i], mutation_rate=mutation_rate)

        population = offspring

    # Select the best solution and corresponding simulation results
    best_solution = min(population, key=lambda x: per_review(*x)[0])
    best_product, best_demand = best_solution

    best_total_cost, best_to = per_review(best_product, best_demand)

    # return best_demand

    # Calculating order lost
    inventory_level_list, tot_dmd, tot_lost, max_inventory = calculate_inventory_levels(best_demand)

    total_demand = sum(tot_dmd)
    unsold_orders = sum(tot_lost) / 12
    # orders_lost_list.append(unsold_orders/total_demand)
    orders_lost_list.append(unsold_orders)

    return total_biaya_penyimpanan_list, to_penyimpanan_list, data_list, demand_result_list, orders_lost_list, inventory_level_list, tot_dmd, tot_lost, max_inventory, best_product, best_demand, best_total_cost, best_to

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
        D = product["permintaan_baku"] / 12
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

    inventory = 0
    review_period = 30
    lead_time = 7
    max_inventory = 1000

    stock = 0
    stockout = 0
    counter = 0

    for day, x in enumerate(demand_result):
        if day % review_period == 0:
            # Placing the order
            q = max_inventory - inventory #+ demand_lead
            order_placed = True

        if order_placed:
            counter += 1

        if counter == lead_time:
            # Restocking day
            inventory += q
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

    return inventory_level, total_demand_list, units_lost_list, max_inventory

# Periodic Review
def periodic_view(request):
    if request.method == 'POST':
        array = []
        data = []

        if 'file' not in request.FILES:
            messages.error(request, "No file was uploaded. Please upload a valid file.")
            return redirect(request.META.get('HTTP_REFERER', '/'))  # Redirect to previous page or fallback

        read_file = request.FILES['file']
        csv_data = pd.read_csv(read_file, header=1, encoding="UTF-8")

        for dt in csv_data.values:
            array_data = {}
            array_data['nama_barang'] = dt[1]
            array_data['biaya_pesan'] = dt[2]
            array_data['permintaan_baku'] = dt[3]
            array_data['biaya_simpan'] = dt[4]
            array_data['biaya_kekurangan'] = dt[5]
            array_data['harga_produk'] = dt[6]
            array_data['lead_time'] = dt[7] / 100
            array_data['standar_deviasi'] = dt[8]

            array.append(array_data)

        # define var
        # iteration_h = 100
        # simulation_num = 100
        pop_size = int(request.POST['population_size'])
        num_generations = int(request.POST['num_generations'])
        crossover_rate = 0.8  # Adjust as needed
        mutation_rate = 0.1

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
            
            tp_list, to_list, data_list, demand_result_list, orders_lost_list, inventory_level_list, total_demand, total_lost, max_inventory, best_product, best_demand, best_total_cost, best_to = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)
            # pop, fit_score, pop_size = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

            # best_demand = genetic_algorithm(product, pop_size, num_generations, crossover_rate, mutation_rate)

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
            plt.clf()

            # grafik biaya inventory
            # plt.hist(tp_list)
            inventory_cost_list = calculate_inventory_cost(data_list, to_list)
            plt.hist(inventory_cost_list, color = "#097969")
            plt.xlabel('Inventory Cost')
            plt.ylabel('Frequency')

            flike = io.BytesIO()
            plt.savefig(flike)
            biaya_inventory_plot = base64.b64encode(flike.getvalue()).decode()
            plt.switch_backend('agg')
            plt.clf()

            # Mencari to paling minimal
            # to_min_index = inventory_cost_list.index(min(inventory_cost_list))
            # to_min = to_list[to_min_index]
            to_min = best_to

            # mc_result = data_list[to_min_index]
            # demand_result = demand_result_list[to_min_index]

            # mc_result = data_list[to_min_index]
            # demand_result = demand_result_list[to_min_index]
            mc_result = best_product
            demand_result = best_demand

            # Mencari s dan S berdasarkan to paling minimal
            R_min, s_min, S_min = find_rss(to_min, mc_result)

            # z = find_rss(to_min, mc_result)

            # return HttpResponse(z)

            # grafik demand
            demand_result_filtered = [i for i in demand_result if i != 0]
            plt.hist(demand_result_filtered, color = "#097969")
            plt.xlabel('Demand')
            plt.ylabel('Frequency')

            flike = io.BytesIO()
            plt.savefig(flike)
            demand_plot = base64.b64encode(flike.getvalue()).decode()
            plt.switch_backend('agg')
            plt.clf()

            # return HttpResponse(', '.join(map(str, inventory_level_list)))

            # grafik inventory level
            # inventory_level_list, tot_dmd, tot_lost = calculate_inventory_levels(demand_result)

            fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(18,6))
            plt.plot(inventory_level_list, linewidth = 1.5)
            plt.axhline(max_inventory, linewidth=2, color="grey", linestyle=":")
            plt.axhline(0, linewidth=2, color="grey", linestyle=":")
            plt.xlim(0,365)
            ax.set_ylabel('Inventory Level (units)', fontsize=18)
            ax.set_xlabel('Day', fontsize=18)

            flike = io.BytesIO()
            plt.savefig(flike)
            inventory_level_plot = base64.b64encode(flike.getvalue()).decode()
            plt.switch_backend('agg')
            plt.clf()
            
            temp = {
                'nama_barang': product["nama_barang"],

                'R': round(R_min),
                's': round(s_min),
                'S': round(S_min),
                'order_lost': round(sum(total_lost) / 12),

                'biaya_inventory_min': round(min(inventory_cost_list)),
                'biaya_inventory_mean': round(np.mean(inventory_cost_list)),
                'biaya_inventory_std': round(np.std(inventory_cost_list)),

                'demand_plot': demand_plot,
                'biaya_inventory_plot': biaya_inventory_plot,
                'inventory_level_plot': inventory_level_plot,
                'simulation_lost_plot': simulation_lost_plot,

                'mc_result': mc_result,
                'demand_result': demand_result,
                'biaya_penyimpanan': 0,
                'total_biaya_penyimpanan': round(to_min, 4),
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