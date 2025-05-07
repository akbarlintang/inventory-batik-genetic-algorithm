from django.forms import ModelForm
from django import forms
from django.utils.translation import gettext_lazy as _

from .models import *

class OutletForm(ModelForm):
    class Meta:
        # merelasikan form dengan model
        model = Outlet
        # mengeset field apa saja yang akan ditampilkan pada form
        fields = ('name', 'address')
        # mengatur teks label untuk setiap field
        labels = {
            'name': _('Outlet Name'),
            'address': _('Outlet Address'),
        }
        # mengatur teks pesan error untuk setiap validasi fieldnya
        error_messages = {
            'name': {
                'required': _("Outlet name is required."),
            },
            'address': {
                'required': _("Outlet address is required."),
            },
        }
        widgets = {
            'name': forms.TextInput(attrs={'placeholder': 'Warehouse A', 'class': 'form-control'}),
            'address': forms.TextInput(attrs={'placeholder': 'Jl. Ahmad Yani No. 34', 'class': 'form-control'}),
        }

class ItemForm(ModelForm):
    class Meta:
        # merelasikan form dengan model
        model = Item
        # mengeset field apa saja yang akan ditampilkan pada form
        fields = ('code', 'name', 'description', 'price', 'type', 'biaya_pesan', 'lead_time')
        # mengatur teks label untuk setiap field
        labels = {
            'code': _('Item Code'),
            'name': _('Item Name'),
            'description': _('Item Description'),
            'price': _('Item Price'),
            'type': _('Item Type'),
            'biaya_pesan': _('Item Order Cost'),
            'lead_time': _('Item Fulfillment Lead Time'),
        }
        # mengatur teks pesan error untuk setiap validasi fieldnya
        error_messages = {
            'code': {
                'required': _("item code is required."),
            },
            'name': {
                'required': _("Item name is required."),
            },
            'description': {
                'required': _("Item description is required."),
            },
            'price': {
                'required': _("Item price is required."),
            },
            'type': {
                'required': _("Item type is required."),
            },
            'biaya_pesan': {
                'required': _("Item order cost is required."),
            },
            'lead_time': {
                'required': _("Item fulfillment lead time is required."),
            },
        }
        widgets = {
            'code': forms.TextInput(attrs={'placeholder': 'CTN-001', 'class': 'form-control'}),
            'name': forms.TextInput(attrs={'placeholder': 'Grade A Cotton', 'class': 'form-control'}),
            'description': forms.TextInput(attrs={'placeholder': 'High-quality cotton fabric', 'class': 'form-control'}),
            'price': forms.TextInput(attrs={'placeholder': '100000', 'class': 'form-control'}),
            'biaya_pesan': forms.TextInput(attrs={'placeholder': '12000', 'class': 'form-control'}),
            'lead_time': forms.TextInput(attrs={'placeholder': '2', 'class': 'form-control'}),
        }

class OutletItemForm(ModelForm):
    price = forms.IntegerField(
        required=True,
        widget=forms.TextInput(attrs={'placeholder': '100000', 'class': 'form-control'})
    )
    lead_time = forms.IntegerField(
        required=True,
        widget=forms.TextInput(attrs={'placeholder': '5', 'class': 'form-control'})
    )

    class Meta:
        # merelasikan form dengan model
        model = Item
        # mengeset field apa saja yang akan ditampilkan pada form
        fields = ('code', 'name', 'description', 'price', 'type', 'biaya_pesan', 'lead_time')
        # mengatur teks label untuk setiap field
        labels = {
            'code': _('Item Code'),
            'name': _('Item Name'),
            'description': _('Item Description'),
            'price': _('Item Price'),
            'type': _('Item Type'),
            'biaya_pesan': _('Item Order Cost'),
            # 'lead_time': _('Item Fulfillment Lead Time'),
        }
        # mengatur teks pesan error untuk setiap validasi fieldnya
        error_messages = {
            'code': {
                'required': _("item code is required."),
            },
            'name': {
                'required': _("Item name is required."),
            },
            'description': {
                'required': _("Item description is required."),
            },
            'price': {
                'required': _("Item price is required."),
            },
            'type': {
                'required': _("Item type is required."),
            },
            'biaya_pesan': {
                'required': _("Item order cost is required."),
            },
            'lead_time': {
                'required': _("Item fulfillment lead time is required."),
            },
        }
        widgets = {
            'code': forms.TextInput(attrs={'placeholder': 'CTN-001', 'class': 'form-control'}),
            'name': forms.TextInput(attrs={'placeholder': 'Grade A Cotton', 'class': 'form-control'}),
            'description': forms.TextInput(attrs={'placeholder': 'High-quality cotton fabric', 'class': 'form-control'}),
            'price': forms.TextInput(attrs={'placeholder': '100000', 'class': 'form-control'}),
            'biaya_pesan': forms.TextInput(attrs={'placeholder': '12000', 'class': 'form-control'}),
            # 'lead_time': forms.TextInput(attrs={'placeholder': '2', 'class': 'form-control'}),
        }
    
    def __init__(self, *args, **kwargs):
        """ Automatically assign the logged-in user's outlet """
        self.user = kwargs.pop('user', None)  # Get the user from the view
        super().__init__(*args, **kwargs)

    def save(self, commit=True):
        """ Save the item first, then create an OutletItem linked to the user's outlet """
        item = super().save(commit=False)
        if commit:
            item.save()

        if self.user and hasattr(self.user, 'employee') and self.user.employee.outlet:
            outlet = self.user.employee.outlet  # Get user's outlet

            # Create OutletItem for the assigned outlet
            OutletItem.objects.create(
                outlet=outlet,
                item=item,
                price=self.cleaned_data['price'],
                lead_time=self.cleaned_data['lead_time']
            )

        return item

class OutletItemEditForm(ModelForm):
    price = forms.IntegerField(
        required=True,
        widget=forms.TextInput(attrs={'placeholder': '100000', 'class': 'form-control'})
    )
    lead_time = forms.IntegerField(
        required=True,
        widget=forms.TextInput(attrs={'placeholder': '91', 'class': 'form-control'})
    )

    class Meta:
        # merelasikan form dengan model
        model = Item
        # mengeset field apa saja yang akan ditampilkan pada form
        fields = ('price', 'lead_time')
        # mengatur teks label untuk setiap field
        labels = {
            'price': _('Item Price'),
            'lead_time': _('Item Fulfillment Lead Time'),
        }
        # mengatur teks pesan error untuk setiap validasi fieldnya
        error_messages = {
            'price': {
                'required': _("Item price is required."),
            },
            'lead_time': {
                'required': _("Item fulfillment lead time is required."),
            },
        }
        widgets = {
            'price': forms.TextInput(attrs={'placeholder': '100000', 'class': 'form-control'}),
            'lead_time': forms.TextInput(attrs={'placeholder': '2', 'class': 'form-control'}),
        }
    
    def __init__(self, *args, **kwargs):
        """ Automatically assign the logged-in user's outlet """
        self.user = kwargs.pop('user', None)  # Get the user from the view
        super().__init__(*args, **kwargs)

    def save(self, commit=True):
        """ Save the item first, then create an OutletItem linked to the user's outlet """
        item = super().save(commit=False)
        if commit:
            item.save()

        if self.user and hasattr(self.user, 'employee') and self.user.employee.outlet:
            outlet = self.user.employee.outlet  # Get user's outlet

            # Create OutletItem for the assigned outlet
            OutletItem.objects.create(
                outlet=outlet,
                item=item,
                price=self.cleaned_data['price'],
                lead_time=self.cleaned_data['lead_time']
            )

        return item

class MaterialForm(ModelForm):
    class Meta:
        # merelasikan form dengan model
        model = Material
        # mengeset field apa saja yang akan ditampilkan pada form
        fields = ('code', 'name', 'description', 'price', 'unit', 'biaya_pesan', 'lead_time')
        # mengatur teks label untuk setiap field
        labels = {
            'code': _('Item Code'),
            'name': _('Item Name'),
            'description': _('Item Description'),
            'price': _('Item Price'),
            'unit': _('Item Unit'),
            'biaya_pesan': _('Item Order Cost (transport, internet, etc.)'),
            'lead_time': _('Item Fulfillment Lead Time (Ordering Duration)'),
        }
        # mengatur teks pesan error untuk setiap validasi fieldnya
        error_messages = {
            'code': {
                'required': _("Item code is required."),
            },
            'name': {
                'required': _("Item name is required."),
            },
            'description': {
                'required': _("Item description is required."),
            },
            'price': {
                'required': _("Item price is required."),
            },
            'unit': {
                'required': _("Item type is required."),
            },
            'biaya_pesan': {
                'required': _("Item order cost is required."),
            },
            'lead_time': {
                'required': _("Item fulfillment lead time is required."),
            },
        }
        widgets = {
            'code': forms.TextInput(attrs={'placeholder': 'C001', 'class': 'form-control'}),
            'name': forms.TextInput(attrs={'placeholder': 'Red Color A', 'class': 'form-control'}),
            'description': forms.TextInput(attrs={'placeholder': 'Red color type A', 'class': 'form-control'}),
            'price': forms.TextInput(attrs={'placeholder': '50000', 'class': 'form-control'}),
            'biaya_pesan': forms.TextInput(attrs={'placeholder': '4000', 'class': 'form-control'}),
            'lead_time': forms.TextInput(attrs={'placeholder': '2', 'class': 'form-control'}),
        }

class PurchaseForm(ModelForm):
    class Meta:
        model = Purchase
        fields = ('outlet', 'item', 'price', 'amount', 'unit')
        labels = {
            'outlet': _('Outlet'),
            'item': _('Item'),
            'price': _('Total Purchase Price'),
            'amount': _('Purchase Quantity'),
            'unit': _('Item Unit'),
        }
        error_messages = {
            'outlet': {
                'required': _("Outlet is required."),
            },
            'item': {
                'required': _("Item is required."),
            },
            'price': {
                'required': _("Price is required."),
            },
            'amount': {
                'required': _("Amount is required."),
            },
            'type': {
                'required': _("Item type is required."),
            },
        }
        widgets = {
            'price': forms.TextInput(attrs={'placeholder': '50000', 'class': 'form-control'}),
            'amount': forms.TextInput(attrs={'placeholder': '10', 'class': 'form-control'}),
        }

class ProductionForm(ModelForm):
    class Meta:
        model = Production
        fields = ('outlet', 'item', 'amount')
        labels = {
            'outlet': _('Outlet'),
            'item': _('Item'),
            'amount': _('Production Amount'),
        }
        error_messages = {
            'outlet': {
                'required': _("Outlet is required."),
            },
            'item': {
                'required': _("Item is required."),
            },
            'amount': {
                'required': _("Production Amount is required."),
            },
        }
        widgets = {
            'amount': forms.TextInput(attrs={'placeholder': '100', 'class': 'form-control'}),
        }

class SalesForm(ModelForm):
    class Meta:
        model = Sales
        fields = ('outlet', 'item', 'price', 'amount', 'unit')
        labels = {
            'outlet': _('Outlet'),
            'item': _('Item'),
            'price': _('Selling Price'),
            'amount': _('Amount'),
            'unit': _('Item Unit'),
        }
        error_messages = {
            'outlet': {
                'required': _("Outlet is required."),
            },
            'item': {
                'required': _("Item is required."),
            },
            'price': {
                'required': _("Selling price is required."),
            },
            'amount': {
                'required': _("Amount is required."),
            },
            'unit': {
                'required': _("Item unit is required."),
            },
        }
        widgets = {
            'price': forms.TextInput(attrs={'placeholder': '120000', 'class': 'form-control'}),
            'amount': forms.TextInput(attrs={'placeholder': '300', 'class': 'form-control'}),
        }

class TransactionForm(ModelForm):
    class Meta:
        model = Transaction
        fields = "__all__"

class RecipeForm(ModelForm):
    class Meta:
        model = Recipe
        exclude = ['item']
        fields = ('outlet', 'material', 'amount')
        labels = {
            'outlet': _('Outlet'),
            'material': _('Material'),
            'amount': _('Material Amount'),
        }
        error_messages = {
            'outlet': {
                'required': _("Outlet is required."),
            },
            'material': {
                'required': _("Material is required."),
            },
            'amount': {
                'required': _("Item amount is required."),
            },
        }
        widgets = {
            'amount': forms.TextInput(attrs={'placeholder': '10', 'class': 'form-control'}),
        }

class EmployeeForm(ModelForm):
    username = forms.CharField(max_length=150, required=True)
    email = forms.EmailField(required=True)
    password = forms.CharField(widget=forms.PasswordInput, required=True)
    
    class Meta:
        model = Employee
        fields = ['outlet', 'role']  # Include role in the form fields, but it will be hidden in the template
    
    def __init__(self, *args, **kwargs):
        outlet_id = kwargs.pop('outlet_id', None)  # Get outlet_id from the view
        super().__init__(*args, **kwargs)
        
        # Set the role field to 'admin' by default
        self.fields['role'].initial = 'admin'
        self.fields['role'].widget = forms.HiddenInput()  # Hide the role field in the UI
        
        # If outlet_id is provided, autofill the outlet field
        if outlet_id:
            self.fields['outlet'].initial = Outlet.objects.get(id=outlet_id)
            self.fields['outlet'].widget = forms.HiddenInput()  # Optionally, hide the outlet field in the UI
    
    def save(self, commit=True):
        # First create the User
        user = User.objects.create_user(
            username=self.cleaned_data['username'],
            password=self.cleaned_data['password'],
            email=self.cleaned_data['email']
        )
        
        # Now create the Employee object
        employee = super().save(commit=False)
        employee.user = user
        
        # Save the Employee object
        if commit:
            employee.save()
        
        return employee