# Generated by Django 3.2.4 on 2024-12-20 12:36

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('inventory', '0003_auto_20241220_1934'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='employee',
            name='outlet',
        ),
        migrations.AddField(
            model_name='employee',
            name='outlet_id',
            field=models.OneToOneField(null=True, on_delete=django.db.models.deletion.CASCADE, to='inventory.outlet'),
        ),
        migrations.AlterModelTable(
            name='employee',
            table='employee',
        ),
    ]
