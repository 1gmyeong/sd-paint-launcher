@echo off


if not defined PYTHON (set PYTHON=python)
if not defined VENV_DIR (set "VENV_DIR=%~dp0%venv")


set ERROR_REPORTING=FALSE

mkdir temp 2>NUL

%PYTHON% -c "" >temp/stdout.txt 2>temp/stderr.txt
if %ERRORLEVEL% == 0 goto :check_pip
echo python�� ��ġ�Ǿ� �ִ��� Ȯ���� �ּ���
goto :show_stdout_stderr

:check_pip
%PYTHON% -mpip --help >temp/stdout.txt 2>temp/stderr.txt
if %ERRORLEVEL% == 0 goto :start_venv
if "%PIP_INSTALLER_LOCATION%" == "" goto :show_stdout_stderr
%PYTHON% "%PIP_INSTALLER_LOCATION%" >temp/stdout.txt 2>temp/stderr.txt
if %ERRORLEVEL% == 0 goto :start_venv
echo python pip�� ��ġ�� �� �����ϴ�
goto :show_stdout_stderr

:start_venv
if ["%VENV_DIR%"] == ["-"] goto :skip_venv
if ["%SKIP_VENV%"] == ["1"] goto :skip_venv

dir "%VENV_DIR%\Scripts\Python.exe" >temp/stdout.txt 2>temp/stderr.txt
if %ERRORLEVEL% == 0 goto :activate_venv

for /f "delims=" %%i in ('CALL %PYTHON% -c "import sys; print(sys.executable)"') do set PYTHON_FULLNAME="%%i"
echo ���� ȯ�� venv ���͸� ���� %VENV_DIR%, ��� python %PYTHON_FULLNAME%
%PYTHON_FULLNAME% -m venv "%VENV_DIR%" >temp/stdout.txt 2>temp/stderr.txt
if %ERRORLEVEL% == 0 goto :activate_venv
echo ���� ȯ�� venv ���͸��� ������ �� �����ϴ� "%VENV_DIR%"
goto :show_stdout_stderr

:activate_venv
set PYTHON="%VENV_DIR%\Scripts\Python.exe"
set ACTIVATE="%VENV_DIR%\Scripts\activate.bat"
echo venv %PYTHON%

:skip_venv
goto :launch

:launch
%ACTIVATE% && %PYTHON% app.py --inbrowser
pause
exit /b

:show_stdout_stderr

echo.
echo exit code: %errorlevel%

for /f %%i in ("temp\stdout.txt") do set size=%%~zi
if %size% equ 0 goto :show_stderr
echo.
echo stdout:
type temp\stdout.txt

:show_stderr
for /f %%i in ("temp\stderr.txt") do set size=%%~zi
if %size% equ 0 goto :show_stderr
echo.
echo stderr:
type temp\stderr.txt

:endofscript

echo.
echo SD Web UI ��ó ���� ����
pause
