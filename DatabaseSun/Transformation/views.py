from django.shortcuts import render
from django.db import connection
from django.http import HttpResponse

def TransformFromFile(request):
    if request.POST:
        try:
            spFeaturesParameter = {}
            cmdCommand = "exec Usp_Core_TransferFromFile "#the sp name script is avalable in folder SQLServerScripts
            if request.POST['tablename']:
                cmdCommand += request.POST['tablename']
            else:
                raise NameError("Table name must be enter")
            if request.POST['filedatapath']:
                cmdCommand += " , " + "'" + request.POST['filedatapath'] + "'"
            else:
                raise NameError("Full path file must be enter")
            if request.POST['fieldterminator']:
                spFeaturesParameter["fieldterminator"]=request.POST['fieldterminator']
            if request.POST['rowterminator']:
                spFeaturesParameter["rowterminator"]=request.POST['rowterminator']
            jsonParameter = "'{"
            for item in spFeaturesParameter:
                jsonParameter += '"' + item + '":"' + spFeaturesParameter[item] + '",'
            jsonParameter = jsonParameter[0:-1]
            jsonParameter += "}'"
            if jsonParameter != "'{}'":
                cmdCommand += ", " + jsonParameter
            #return HttpResponse(cmdCommand) #this code help you for see what created before exec
            with connection.cursor() as cursor:
            #    cusror.callProc("Usp_Core_TransferFromFile",[request.POST['tablename'],request.POST['fieldterminator'],jsonParameter])# use this code if you want call mysql or other database or use Django mssql
                cursor.execute(cmdCommand)
            return HttpResponse('Data translate successfully')
        except Exception as ex:
            return HttpResponse('Translation fall because : ' + ex.__str__())
    else:
        return render(request,'Transformation\TransformFilePage.html')
