function varargout = calibrate(varargin)
% CALIBRATE MATLAB code for calibrate.fig
%      CALIBRATE, by itself, creates a new CALIBRATE or raises the existing
%      singleton*.
%
%      H = CALIBRATE returns the handle to a new CALIBRATE or the handle to
%      the existing singleton*.
%
%      CALIBRATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATE.M with the given input arguments.
%
%      CALIBRATE('Property','Value',...) creates a new CALIBRATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibrate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibrate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibrate

% Last Modified by GUIDE v2.5 28-Sep-2017 22:25:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calibrate_OpeningFcn, ...
                   'gui_OutputFcn',  @calibrate_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before calibrate is made visible.
function calibrate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibrate (see VARARGIN)

% Choose default command line output for calibrate
handles.output = hObject;
cross = imread('cross.png','BackgroundColor', [1 1 1]);
axes(handles.OpenStatusP1);
image(cross);
axis off
axis image
axes(handles.ShortStatusP1);
image(cross);
axis off
axis image
axes(handles.MatchStatusP1);
image(cross);
axis off
axis image
axes(handles.OpenStatusP2);
image(cross);
axis off
axis image
axes(handles.ShortStatusP2);
image(cross);
axis off
axis image
axes(handles.MatchStatusP2);
image(cross);
axis off
axis image
axes(handles.TrgStatus);
image(cross);
axis off
axis image
handles.S11_open = [];
handles.S11_short = [];
handles.S11_match = [];
handles.S22_open = [];
handles.S22_short = [];
handles.S22_match = [];
handles.S11_thru = [];
handles.S22_thru = [];
handles.S21_thru = [];
handles.S12_thru = [];
[doneSound,doneFs] = audioread('done.mp3');
handles.doneSound = doneSound;
handles.doneFs = doneFs;
%sound(handles.doneSound, handles.doneFs)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibrate wait for user response (see UIRESUME)
% uiwait(handles.calibrateWindow);


% --- Outputs from this function are returned to the command line.
function varargout = calibrate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function calibrateWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calibrateWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function OpenOffsetP1_Callback(hObject, eventdata, handles)
% hObject    handle to OpenOffsetP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OpenOffsetP1 as text
%        str2double(get(hObject,'String')) returns contents of OpenOffsetP1 as a double


% --- Executes during object creation, after setting all properties.
function OpenOffsetP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenOffsetP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenCalP1.
function OpenCalP1_Callback(hObject, eventdata, handles)
% hObject    handle to OpenCalP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.OpenCalP1,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'FORDWARD');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 0.1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 0.1;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 0.1;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 0.2;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 0.2;
    pause(1);
end
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.OpenCalP1,'String', 'Open');
handles.S11_open = gamma_Complex(:,1);
handles.S11_o_pha_v = Pha_v(: , 1);
handles.S11_o_mod_v = Mag_v(: , 1);
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v(: , 1),Pha_v(: , 1)],'./calibracion/OpenP1_v','.');

tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.OpenStatusP1);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_short) && ~isempty(handles.S11_match) && ~isempty(handles.S22_match) && ~isempty(handles.S22_short) && ~isempty(handles.S22_open) && ~isempty(handles.S11_thru) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);


% --- Executes on button press in ShortCalP1.
function ShortCalP1_Callback(hObject, eventdata, handles)
% hObject    handle to ShortCalP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.ShortCalP1,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'FORDWARD');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 0.3;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 0.3;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 0.4;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 0.4;
    pause(1);
end
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.ShortCalP1,'String', 'Short');
handles.S11_short = gamma_Complex(:,1);
handles.S11_s_pha_v = Pha_v(: , 1);
handles.S11_s_mod_v = Mag_v(: , 1);
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v(: , 1),Pha_v(: , 1)],'./calibracion/ShortP1_v','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.ShortStatusP1);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_match) && ~isempty(handles.S11_open) && ~isempty(handles.S22_match) && ~isempty(handles.S22_short) && ~isempty(handles.S22_open) && ~isempty(handles.S11_thru) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);

% --- Executes on button press in MatchCalP1.
function MatchCalP1_Callback(hObject, eventdata, handles)
% hObject    handle to MatchCalP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.MatchCalP1,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'FORDWARD');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 0.5;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 0.5;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 0.6;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 0.6;
    pause(1);
end
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.MatchCalP1,'String', 'Match');
handles.S11_match = gamma_Complex(:,1);
handles.S11_m_pha_v = Pha_v(: , 1);
handles.S11_m_mod_v = Mag_v(: , 1);
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v(: , 1),Pha_v(: , 1)],'./calibracion/MatchP1_v','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.MatchStatusP1);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_short) && ~isempty(handles.S11_open) && ~isempty(handles.S22_match) && ~isempty(handles.S22_short) && ~isempty(handles.S22_open) && ~isempty(handles.S11_thru) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);


% --- Executes on button press in doneCal.
function doneCal_Callback(hObject, eventdata, handles)
% hObject    handle to doneCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
OpenOffsetP1 = str2double(get(handles.OpenOffsetP1, 'String'));
ShortOffsetP1 = str2double(get(handles.ShortOffsetP1, 'String'));
OpenOffsetP2 = str2double(get(handles.OpenOffsetP2, 'String'));
ShortOffsetP2 = str2double(get(handles.ShortOffsetP2, 'String'));
if(isempty(OpenOffsetP1) || isempty(ShortOffsetP1) || isempty(OpenOffsetP2) || isempty(ShortOffsetP2))
   warndlg('Los offsets especificados son inv�lidos. Dicho valor debe ser un n�mero real positivo o cero. Use . para separar los decimales.','Offsets Inv�lidos'); 
else

    remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
    calibrationOutput.S11_open = handles.S11_open;
    calibrationOutput.S11_short = handles.S11_short;
    calibrationOutput.S11_match = handles.S11_match;
    calibrationOutput.openOffsetP1 = OpenOffsetP1/1000; % mm a metros
    calibrationOutput.shortOffsetP1= ShortOffsetP1/1000; % mm a metros    
    calibrationOutput.S22_open = handles.S22_open;
    calibrationOutput.S22_short = handles.S22_short;
    calibrationOutput.S22_match = handles.S22_match;
    calibrationOutput.S11_thru = handles.S11_thru;
    calibrationOutput.S22_thru = handles.S22_thru;
    calibrationOutput.S21_thru = handles.S21_thru;
    calibrationOutput.S12_thru = handles.S12_thru;
    calibrationOutput.openOffsetP2 = OpenOffsetP2/1000; % mm a metros
    calibrationOutput.shortOffsetP2= ShortOffsetP2/1000; % mm a metros  
    setappdata(remoteHandles.backHandle, 'calibrationOutput', calibrationOutput);

    if (remoteHandles.DebugMode == 0)
        [file, path] = uiputfile('./temp/calibration.mat','Exportar Medici�n'); %Prompt para guardar archivo
    else
        [file, path] = uiputfile('./temp/calibration_dummy.mat','Exportar Medici�n');
    end
    if (path>0) 
        freqOSM = reshape(remoteHandles.freqVector,length(remoteHandles.freqVector),1);
        S11_open=handles.S11_open;
        S11_short=handles.S11_short;
        S11_match=handles.S11_match;
        S22_open=handles.S22_open;
        S22_short=handles.S22_short;
        S22_match=handles.S22_match;
        S11_thru=handles.S11_thru;
        S22_thru=handles.S22_thru;
        S12_thru=handles.S12_thru;
        S21_thru=handles.S21_thru;
        save([path,file],'freqOSM','S11_open','S11_short','S11_match',...
        'S22_open','S22_short','S22_match',...
        'S11_thru','S22_thru','S21_thru','S12_thru' ...
        );


        % ----OutputFile Calibration Values in Complex----- %
        names = ["Freq","S11_open","S11_short","S11_match",...
            "S22_open","S22_short","S22_match",...
            "S11_thru","S22_thru","S21_thru","S12_thru" ];

        values = [freqOSM,S11_open,S11_short,S11_match,...
            S22_open,S22_short,S22_match,...
            S11_thru,S22_thru,S21_thru,S12_thru ];

        outputfile = './temp/forDebug/calibration_complex_values.csv';

        writematrix(names,outputfile);
        writematrix(values,outputfile,'WriteMode','append');

        
        % ----OutputFile Calibration Values in Voltage----- %
        handles.calibration_values = [freqOSM,handles.S11_o_mod_v,handles.S11_o_pha_v,handles.S11_s_mod_v,handles.S11_s_pha_v,handles.S11_m_mod_v,handles.S11_m_pha_v,...
            handles.S22_o_mod_v,handles.S22_o_pha_v,handles.S22_s_mod_v,handles.S22_s_pha_v,handles.S22_m_mod_v,handles.S22_m_pha_v,...
            handles.S11_thru_mod_v,handles.S11_thru_pha_v,handles.S21_thru_mod_v,handles.S21_thru_pha_v,...
            handles.S12_thru_mod_v,handles.S12_thru_pha_v,handles.S22_thru_mod_v,handles.S22_thru_pha_v...
            ];

        handles.calibration_names = ["Freq","S11_o_mod_v","S11_o_pha_v","S11_s_mod_v","S11_s_pha_v","S11_m_mod_v","S11_m_pha_v",...
            "S22_o_mod_v","S22_o_pha_v","S22_s_mod_v","S22_s_pha_v","S22_m_mod_v","S22_m_pha_v",...
            "S11_thru_mod_v","S11_thru_pha_v","S21_thru_mod_v","S21_thru_pha_v",...
            "S12_thru_mod_v","S12_thru_pha_v","S22_thru_mod_v","S22_thru_pha_v"...
            ];

        writematrix(handles.calibration_names,'./temp/forDebug/calibration_voltage_value.csv');
        writematrix(handles.calibration_values,'./temp/forDebug/calibration_voltage_value.csv','WriteMode','append')
        
        % ----Save Workspace Calibration Values in Voltage----- %
        save('./temp/forDebug/calibration_voltage_value.mat','-struct','handles', 'calibration_names',...
        'S11_o_mod_v','S11_o_pha_v','S11_s_mod_v','S11_s_pha_v','S11_m_mod_v','S11_m_pha_v',...
        'S22_o_mod_v','S22_o_pha_v','S22_s_mod_v','S22_s_pha_v','S22_m_mod_v','S22_m_pha_v',...
        'S11_thru_mod_v','S11_thru_pha_v','S21_thru_mod_v','S21_thru_pha_v',...
        'S12_thru_mod_v','S12_thru_pha_v','S22_thru_mod_v','S22_thru_pha_v'...
        );
        save('./temp/forDebug/calibration_voltage_value.mat','freqOSM',"-append")
    end 

    close(calibrate);
    
    end
    
    
  function ShortOffsetP1_Callback(hObject, eventdata, handles)
% hObject    handle to ShortOffsetP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShortOffsetP1 as text
%        str2double(get(hObject,'String')) returns contents of ShortOffsetP1 as a double

   
% --- Executes during object creation, after setting all properties.
function ShortOffsetP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShortOffsetP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function OpenStatusP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenStatusP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate OpenStatusP1



function OpenOffsetP2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenOffsetP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OpenOffsetP2 as text
%        str2double(get(hObject,'String')) returns contents of OpenOffsetP2 as a double


% --- Executes during object creation, after setting all properties.
function OpenOffsetP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpenOffsetP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenCalP2.
function OpenCalP2_Callback(hObject, eventdata, handles)
% hObject    handle to OpenCalP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.OpenCalP2,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'REVERSE');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 0.7;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 0.7;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 0.8;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 0.8;
    pause(1);
end
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.OpenCalP2,'String', 'Open');
handles.S22_open = gamma_Complex(:,4);
handles.S22_o_pha_v = Pha_v(: , 4);
handles.S22_o_mod_v = Mag_v(: , 4);
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v(: , 4),Pha_v(: , 4)],'./calibracion/OpenP2_v','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.OpenStatusP2);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_short) && ~isempty(handles.S11_match) && ~isempty(handles.S22_match) && ~isempty(handles.S22_short) && ~isempty(handles.S11_open) && ~isempty(handles.S11_thru) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);

% --- Executes on button press in ShortCalP2.
function ShortCalP2_Callback(hObject, eventdata, handles)
% hObject    handle to ShortCalP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.ShortCalP2,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'REVERSE');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 0.9;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 0.9;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 1.1;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 1.1;
    pause(1);
end
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.ShortCalP2,'String', 'Short');
handles.S22_short = gamma_Complex(:,4);
handles.S22_s_pha_v = Pha_v(: , 4);
handles.S22_s_mod_v = Mag_v(: , 4);
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v(: , 4),Pha_v(: , 4)],'./calibracion/ShortP2_v','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.ShortStatusP2);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_match) && ~isempty(handles.S11_open) && ~isempty(handles.S22_match) && ~isempty(handles.S11_short) && ~isempty(handles.S22_open) && ~isempty(handles.S11_thru) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);

% --- Executes on button press in MatchCalP2.
function MatchCalP2_Callback(hObject, eventdata, handles)
% hObject    handle to MatchCalP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.MatchCalP2,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'REVERSE');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 1.2;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 1.2;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 1.3;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 1.3;
    pause(1);
end
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.MatchCalP2,'String', 'Match');
handles.S22_match = gamma_Complex(:,4);
handles.S22_m_pha_v = Pha_v(: , 4);
handles.S22_m_mod_v = Mag_v(: , 4);
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v(: , 4),Pha_v(: , 4)],'./calibracion/MatchP2_v','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.MatchStatusP2);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_short) && ~isempty(handles.S11_open) && ~isempty(handles.S11_match) && ~isempty(handles.S22_short) && ~isempty(handles.S22_open) && ~isempty(handles.S11_thru) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);


function ShortOffsetP2_Callback(hObject, eventdata, handles)
% hObject    handle to ShortOffsetP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShortOffsetP2 as text
%        str2double(get(hObject,'String')) returns contents of ShortOffsetP2 as a double


% --- Executes during object creation, after setting all properties.
function ShortOffsetP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShortOffsetP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ThroughCal.
function ThroughCal_Callback(hObject, eventdata, handles)
% hObject    handle to ThroughCal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to MatchCalP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
remoteHandles = getappdata(handles.calibrateWindow, 'remoteData');
set(handles.OpenCalP1, 'Enable', 'off');
set(handles.ShortCalP1, 'Enable', 'off');
set(handles.MatchCalP1, 'Enable', 'off')
set(handles.doneCal, 'Enable', 'off');
set(handles.OpenCalP2, 'Enable', 'off');
set(handles.ShortCalP2, 'Enable', 'off');
set(handles.MatchCalP2, 'Enable', 'off');
set(handles.ThroughCal, 'Enable', 'off')
set(handles.ThroughCal,'String', 'Espere');
if (remoteHandles.DebugMode ==0)
    [gamma_Complex, Mag, Mag_v, Pha, Pha_v] = acquireData(remoteHandles,'FULL');
else
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 4) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 4) + 1.4;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 4) + 1.4;
    [Pha] = zeros(length(remoteHandles.freqVector), 4) + 1.5;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 4) + 1.5;
    pause(1);
end

handles.S11_thru = gamma_Complex(:,1);
handles.S11_thru_pha_v = Pha_v(:,1);
handles.S11_thru_mod_v = Mag_v(:,1);
handles.S21_thru = gamma_Complex(:,2);
handles.S21_thru_pha_v = Pha_v(:,2);
handles.S21_thru_mod_v = Mag_v(:,2);

handles.S12_thru = gamma_Complex(:,3);
handles.S12_thru_pha_v = Pha_v(:,3);
handles.S12_thru_mod_v = Mag_v(:,3);
handles.S22_thru = gamma_Complex(:,4);
handles.S22_thru_pha_v = Pha_v(:,4);
handles.S22_thru_mod_v = Mag_v(:,4);


freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,Mag_v,Pha_v],'./calibracion/Trough_v','.'); %Seguramente haya un error en como crea el archivo
set(handles.OpenCalP1, 'Enable', 'on');
set(handles.ShortCalP1, 'Enable', 'on');
set(handles.MatchCalP1, 'Enable', 'on');
set(handles.OpenCalP2, 'Enable', 'on');
set(handles.ShortCalP2, 'Enable', 'on');
set(handles.MatchCalP2, 'Enable', 'on');
set(handles.ThroughCal, 'Enable', 'on')
set(handles.ThroughCal,'String', 'Through');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.TrgStatus);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.S11_short) && ~isempty(handles.S11_open) && ~isempty(handles.S11_match) && ~isempty(handles.S22_short) && ~isempty(handles.S22_open) && ~isempty(handles.S22_match) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);
