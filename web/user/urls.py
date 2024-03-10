from django.urls import path
from user import views
app_name="webuser"

urlpatterns = [
        path('Reg/',views.reg,name="reg"),
        path('',views.login,name="login"),
        path('homepage/',views.homepage,name="homepage"),
        path('qrcode/',views.generate_qrcode,name='qrcode')
]
