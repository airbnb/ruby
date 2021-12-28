from django.shortcuts import render

def xss_path(request, path='default'):
    # ruleid: context-autoescape-off
    env = {'autoescape': False, 'path': path}
    return render(request, 'vulnerable/xss/path.html', env)

def file_access(request):
    msg = request.GET.get('msg', '')
    # ok: context-autoescape-off
    return render(request, 'ok.html',  {'msg': msg})