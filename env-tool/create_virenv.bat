@REM @Author: wangqiang
@REM @Date:   2020-02-15 10:23:51
@REM @Last Modified by:   wqiang
@REM Modified time: 2020-02-15 21:43:09

@echo off
rem 文件设置为utf8,同时代码中显示切成utf-8代码页，保证文件在传输和显示过程一致，不会出现乱码
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ****************step1:虚拟环境设置**********************************

rem set "project_path=%~dp0"
echo 当前目录:%cd%
echo.
:_set_virtualenv_path
set /p virtualenv_path=请设置虚拟环境目录(默认为当前目录):
if not defined virtualenv_path (set virtualenv_path=%cd%)
if exist "%virtualenv_path%" (
    echo.virtualenv_path=%virtualenv_path%
    ) else (
    echo 错误：目录不存在，请重新设置！
    goto _set_virtualenv_path )

echo.
where python > .\python_path.txt
for /f %%i in (.\python_path.txt) do (
    set path1=%%i
    echo !path1!|findstr "python.exe$" >nul ||( echo python环境不正确，请确认！ & echo !path1! & pause & exit )
    echo %%i
    %%i --version)

echo.
:_set_local_path
set local_python_file=
set /p local_python_file=请设置本地python(默认为第一个)：
if not defined local_python_file (set /p local_python_file=<"python_path.txt" )

if exist "%local_python_file%" (
    echo.local_python_file:%local_python_file%
    ) else (
    echo 错误：文件不存在，请重新设置！
    goto _set_local_path )

:_set_virtualenv_name
set virtualenv_name=
echo.
set /p virtualenv_name=请设置虚拟环境名称：
if defined virtualenv_name (
    echo.virtualenv_name=%virtualenv_name%
    ) else (
    echo 错误：名称不能为空，请重新设置！
    goto _set_virtualenv_name )


echo ****************step2:构建虚拟环境**********************************
set activate_path="%virtualenv_path%/%virtualenv_name%/Scripts/activate"
if exist %activate_path% (
    echo 虚拟环境已存在，python版本：
    call "%virtualenv_path%/%virtualenv_name%/Scripts/python" --version
    echo.
    set /p is_continue=是否继续?[默认Y] [Y/N]:
    if /i '!is_continue!'=='N' ( goto _is_test )
    )

cd /d "%virtualenv_path%"
pip install virtualenv && virtualenv  --no-site-packages -p %local_python_file% %virtualenv_name% && echo 虚拟环境已创建.

:_is_test
echo ****************step3:测试虚拟环境**********************************
set /p is_test=是否测试虚拟环境? [Y/N]:
if /i '%is_test%'=='Y' goto _test_virtual
if /i '%is_test%'=='N' exit
if /i not '%is_test%'=='N' if /i not '%is_test%'=='Y' echo.非法输入，请重新输入. && goto _is_test


:_test_virtual
start cmd /k "cd/d %virtualenv_path%/%virtualenv_name%/Scripts && activate && echo 虚拟环境已激活. && python --version && pip list && deactivate && echo 虚拟环境已停止."
echo 测试完成.
pause

