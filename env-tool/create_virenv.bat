@REM @Author: wangqiang
@REM @Date:   2020-02-15 10:23:51
@REM @Last Modified by:   wqiang
@REM Modified time: 2020-02-15 17:20:39



@echo off
setlocal enabledelayedexpansion

echo ****************step1:���⻷������**********************

rem set "project_path=%~dp0"
echo ��ǰĿ¼:%cd%
echo.
:_set_virtualenv_path
set /p virtualenv_path=���������⻷��Ŀ¼:
if not defined "%virtualenv_path%" (set virtualenv_path=%cd%)
if exist "%virtualenv_path%" (
    echo.virtualenv_path=%virtualenv_path%
    ) else (
    echo ����Ŀ¼�����ڣ����������ã�
    goto _set_virtualenv_path )

echo.
where python > .\python_path.txt
for /f %%i in (.\python_path.txt) do (
    set path1=%%i
    echo !path1!|findstr "python.exe$" >nul ||( echo python��������ȷ����ȷ�ϣ� & echo !path1! & pause & exit )
    echo %%i
    %%i --version)

set /p python_path=<"python_path.txt"
echo.
:_set_local_path
set local_python_path=
set /p local_python_path=�����ñ���python·����
if not defined "%local_python_path%" (set /p local_python_path=<"python_path.txt")
if exist "%local_python_path%" (
    echo.local_python_path:%local_python_path%
    ) else (
    echo �����ļ������ڣ����������ã�
    goto _set_local_path )

:_set_virtualenv_name
set virtualenv_name=
echo.
set /p virtualenv_name=���������⻷�����ƣ�
if defined virtualenv_name (
    echo.virtualenv_name=%virtualenv_name%
    ) else (
    echo ���Ʋ���Ϊ�գ����������ã�
    goto _set_virtualenv_name )


echo ****************step2:�������⻷��%virtualenv_name%***********************
set activate_path="%virtualenv_path%/%virtualenv_name%/Scripts/activate"
if exist %activate_path% (
    echo ���⻷���Ѵ��ڣ�python�汾��
    call "%virtualenv_path%/%virtualenv_name%/Scripts/python" --version
    echo.
    set /p is_continue=�Ƿ����?[Ĭ��Y] [Y/N]:
    if /i '!is_continue!'=='N' ( goto _is_test )
    )

cd /d "%virtualenv_path%"
pip install virtualenv && virtualenv  --no-site-packages -p %local_python_path% %virtualenv_name% && echo ���⻷���Ѵ���.

:_is_test
echo ****************step3:�������⻷��****************************
set /p is_test=�Ƿ�������⻷��? [Y/N]:
if /i '%is_test%'=='Y' goto _test_virtual
if /i '%is_test%'=='N' exit
if /i not '%is_test%'=='N' if /i not '%is_test%'=='Y' echo.�Ƿ����룬����������. && goto _is_test


:_test_virtual
start cmd /k "cd/d %virtualenv_path%/%virtualenv_name%/Scripts && activate && echo ���⻷���Ѽ���. && python --version && pip list && deactivate && echo ���⻷����ֹͣ."
echo �������.
pause

