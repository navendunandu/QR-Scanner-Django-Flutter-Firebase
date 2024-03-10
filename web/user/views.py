from django.shortcuts import render,redirect
import firebase_admin 
from firebase_admin import firestore,credentials,storage,auth
import pyrebase
import qrcode
from io import BytesIO
from django.core.files.base import ContentFile
from django.core.files.storage import default_storage
from django.http import HttpResponse
import json


# Create your views here.
db=firestore.client()

config = {
 
  "apiKey": "AIzaSyCavj6asb1VbarAJD3aCn6oysUyzbEbmFQ",
  "authDomain": "qrcode-8d607.firebaseapp.com",
  "projectId": "qrcode-8d607",
  "storageBucket": "qrcode-8d607.appspot.com",
  "messagingSenderId": "327116824967",
  "appId": "1:327116824967:web:404294d433d6401b717322",
  "measurementId": "G-2QG7F90ZK4",
  "databaseURL":""
}

firebase = pyrebase.initialize_app(config)
authe = firebase.auth()
st = firebase.storage()


def reg(request):
    if request.method =="POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        try:
            user = firebase_admin.auth.create_user(email=email,password=password)
        except (firebase_admin._auth_utils.EmailAlreadyExistsError,ValueError) as error:
            return render(request,"user/Reg.html",{"msg":error})
        db.collection("tbl_user").add({"user_id":user.uid,"user_name":request.POST.get("name"),"user_email":request.POST.get("email")})    
    return render(request,'user/Reg.html')

def login(request):
    userid=""
    if request.method == "POST":
        email = request.POST.get("email")
        password = request.POST.get("password")
        try:
            data = authe.sign_in_with_email_and_password(email,password)
        except:
            return render(request,"Guest/Login.html",{"msg":"Error in Email Or Password"})    
        user=db.collection("tbl_user").where("user_id","==",data["localId"]).stream()
        for u in user:
            userid=u.id   
        if userid:
            request.session["uid"]=userid
            return redirect("webuser:homepage") 
        else:
            return render(request,"user/login.html")  
    else:
        return render(request,"user/login.html") 


def homepage(request):
    user = db.collection('tbl_user').document(request.session['uid']).get().to_dict()
    return render(request,"user/homepage.html",{'data':user})

def generate_qrcode(request):
    user = db.collection('tbl_user').document(request.session['uid']).get().to_dict()
    user_data = {'username': user['user_name'], 'id': user['user_id']}
    user_data_json = json.dumps(user_data)
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(user_data_json)
    qr.make(fit=True)
    qr_img = qr.make_image(fill_color="black", back_color="white")
    buffer = BytesIO()
    qr_img.save(buffer)
    buffer.seek(0)
    return HttpResponse(buffer.getvalue(), content_type='image/png')
