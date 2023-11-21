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
    [gamma_Complex] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [Mag] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [Mag_v] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [Pha] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [Pha_v] = zeros(length(remoteHandles.freqVector), 1) + 1;
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
handles.gammaOpenP1 = gamma_Complex;
handles.openPhaseCountsP1 = phaseV;
handles.openModCountsP1 = modV;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV,phaseV],'OpenP1 Crudo','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.OpenStatusP1);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.gammaShortP1) && ~isempty(handles.gammaMatchP1) && ~isempty(handles.gammaMatchP2) && ~isempty(handles.gammaShortP2) && ~isempty(handles.gammaOpenP2) && ~isempty(handles.gammaTP1) )% terminar de poner todos los vectores de calibracion
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
    [gammaShort, phaseV, modV,~,~,~] = acquireData(remoteHandles,'FORDWARD');
else
    [gammaShort] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [modV] = zeros(length(remoteHandles.freqVector), 1) + 1;
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
handles.gammaShortP1 = gammaShort;
handles.shortPhaseCountsP1 = phaseV;
handles.shortModCountsP1 = modV;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV,phaseV],'ShortP1 Crudo','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.ShortStatusP1);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.gammaMatchP1) && ~isempty(handles.gammaOpenP1) && ~isempty(handles.gammaMatchP2) && ~isempty(handles.gammaShortP2) && ~isempty(handles.gammaOpenP2) && ~isempty(handles.gammaTP1) )% terminar de poner todos los vectores de calibracion
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
    [gammaMatch, phaseV, modV,~,~,~] = acquireData(remoteHandles,'FORDWARD');
else
    [gammaMatch] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [modV] = zeros(length(remoteHandles.freqVector), 1) + 1;
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
handles.gammaMatchP1 = gammaMatch;
handles.matchPhaseCountsP1 = phaseV;
handles.matchModCountsP1 = modV;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV,phaseV],'MatchP1 Crudo','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.MatchStatusP1);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.gammaShortP1) && ~isempty(handles.gammaOpenP1) && ~isempty(handles.gammaMatchP2) && ~isempty(handles.gammaShortP2) && ~isempty(handles.gammaOpenP2) && ~isempty(handles.gammaTP1) )% terminar de poner todos los vectores de calibracion
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
    calibrationOutput.gammaOpenP1 = handles.gammaOpenP1;
    calibrationOutput.gammaShortP1 = handles.gammaShortP1;
    calibrationOutput.gammaMatchP1 = handles.gammaMatchP1;
    calibrationOutput.openOffsetP1 = OpenOffsetP1/1000; % mm a metros
    calibrationOutput.shortOffsetP1= ShortOffsetP1/1000; % mm a metros    
    calibrationOutput.gammaOpenP2 = handles.gammaOpenP2;
    calibrationOutput.gammaShortP2 = handles.gammaShortP2;
    calibrationOutput.gammaMatchP2 = handles.gammaMatchP2;
    calibrationOutput.gammaTP1 = handles.gammaTP1;
    calibrationOutput.gammaTP2 = handles.gammaTP2;
    calibrationOutput.forwardT = handles.forwardT;
    calibrationOutput.reverseT = handles.reverseT;
    calibrationOutput.openOffsetP2 = OpenOffsetP2/1000; % mm a metros
    calibrationOutput.shortOffsetP2= ShortOffsetP2/1000; % mm a metros  
    setappdata(remoteHandles.backHandle, 'calibrationOutput', calibrationOutput);
    if (remoteHandles.DebugMode == 0)
        [file, path] = uiputfile('calibracion cuentas.mat','Exportar Medici�n'); %Prompt para guardar archivo
        if (path>0) 
            freqOSM = remoteHandles.freqVector;
            openModCountsP1 = handles.openModCountsP1;
            openPhaseCountsP1 = handles.openPhaseCountsP1;
            shortModCountsP1 = handles.shortModCountsP1;
            shortPhaseCountsP1 = handles.shortPhaseCountsP1;
            matchPhaseCountsP1 = handles.matchPhaseCountsP1;
            matchModCountsP1 = handles.matchModCountsP1;
            openModCountsP2 = handles.openModCountsP2;
            openPhaseCountsP2 = handles.openPhaseCountsP2;
            shortModCountsP2 = handles.shortModCountsP2;
            shortPhaseCountsP2 = handles.shortPhaseCountsP2;
            matchPhaseCountsP2 = handles.matchPhaseCountsP2;
            matchModCountsP2 = handles.matchModCountsP2;
            gammaTP1ModCounts = handles.gammaTP1ModCounts;
            gammaTP2ModCounts = handles.gammaTP2ModCounts;
            gammaTP1PhaseCounts = handles.gammaTP1PhaseCounts;
            gammaTP2PhaseCounts = handles.gammaTP2PhaseCounts;
            forwardTModCounts = handles.forwardTModCounts;
            reverseTModCounts = handles.reverseTModCounts;
            forwardTPhaseCounts = handles.forwardTPhaseCounts;
            reverseTPhaseCounts = handles.reverseTPhaseCounts;
            gammaOpenP1=handles.gammaOpenP1;
            gammaShortP1=handles.gammaShortP1;
            gammaMatchP1=handles.gammaMatchP1;
            gammaOpenP2=handles.gammaOpenP2;
            gammaShortP2=handles.gammaShortP2;
            gammaMatchP2=handles.gammaMatchP2;
            gammaTP1=handles.gammaTP1;
            gammaTP2=handles.gammaTP2;
            reverseT=handles.reverseT;
            forwardT=handles.forwardT;
            save([path,file],'freqOSM','gammaOpenP1','gammaShortP1','gammaMatchP1','gammaOpenP2','gammaShortP2','gammaMatchP2','gammaTP1','gammaTP2','forwardT','reverseT' );
            %frecs=reshape(freqOSM,length(freqOSM),1);
            %creaSxP([frecs,shortModCountsP2,shortPhaseCountsP2],'ShortP2 Crudo','.');
            %creaSxP([frecs,shortModCountsP1,shortPhaseCountsP1],'ShortP1 Crudo','.');
            %creaSxP([frecs,openModCountsP2,openPhaseCountsP2],'OpenP2 Crudo','.');
            %creaSxP([frecs,openModCountsP1,openPhaseCountsP1],'OpenP1 Crudo','.');
            %creaSxP([frecs,matchModCountsP2,matchPhaseCountsP2],'MatchP2 Crudo','.');
            %creaSxP([frecs,matchModCountsP1,matchPhaseCountsP1],'MatchP1 Crudo','.');
            %creaSxP([frecs,gammaTP1ModCounts,reverseTModCounts,forwardTModCounts,gammaTP2ModCounts,gammaTP1PhaseCounts,reverseTPhaseCounts,forwardTPhaseCounts,gammaTP2PhaseCounts],'Trough Crudo','.');
        end 
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
    [gammaOpen, phaseV, modV,~,~,~] = acquireData(remoteHandles,'REVERSE');
else
    [gammaOpen] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [modV] = zeros(length(remoteHandles.freqVector), 1) + 1;
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
handles.gammaOpenP2 = gammaOpen;
handles.openPhaseCountsP2 = phaseV;
handles.openModCountsP2 = modV;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV,phaseV],'OpenP2 Crudo','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.OpenStatusP2);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.gammaShortP1) && ~isempty(handles.gammaMatchP1) && ~isempty(handles.gammaMatchP2) && ~isempty(handles.gammaShortP2) && ~isempty(handles.gammaOpenP1) && ~isempty(handles.gammaTP1) )% terminar de poner todos los vectores de calibracion
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
    [gammaShort, phaseV, modV,~,~,~] = acquireData(remoteHandles,'REVERSE');
else
    [gammaShort] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV] = zeros(length(remoteHandles.freqVector), 1) +180;
    [modV] = zeros(length(remoteHandles.freqVector), 1) + 1;
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
handles.gammaShortP2 = gammaShort;
handles.shortPhaseCountsP2 = phaseV;
handles.shortModCountsP2 = modV;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV,phaseV],'ShortP2 Crudo','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.ShortStatusP2);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.gammaMatchP1) && ~isempty(handles.gammaOpenP1) && ~isempty(handles.gammaMatchP2) && ~isempty(handles.gammaShortP1) && ~isempty(handles.gammaOpenP2) && ~isempty(handles.gammaTP1) )% terminar de poner todos los vectores de calibracion
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
    [gammaMatch, phaseV, modV,~,~,~] = acquireData(remoteHandles,'REVERSE');
else
    [gammaMatch] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [modV] = zeros(length(remoteHandles.freqVector), 1) + 1;
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
handles.gammaMatchP2 = gammaMatch;
handles.matchPhaseCountsP2 = phaseV;
handles.matchModCountsP2 = modV;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV,phaseV],'MatchP2 Crudo','.');
tick = imread('tick.png','BackgroundColor', [1 1 1]);
axes(handles.MatchStatusP2);
image(tick);
axis off
axis image
sound(handles.doneSound, handles.doneFs);
if(~isempty(handles.gammaShortP1) && ~isempty(handles.gammaOpenP1) && ~isempty(handles.gammaMatchP1) && ~isempty(handles.gammaShortP2) && ~isempty(handles.gammaOpenP2) && ~isempty(handles.gammaTP1) )% terminar de poner todos los vectores de calibracion
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
    [gammaTP2, phaseV, modV,reverseT,phaseV2,modV2] = acquireData(remoteHandles,'REVERSE');
else
    [gammaTP2] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV] = zeros(length(remoteHandles.freqVector), 1) + 0;
    [modV] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [reverseT] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV2] = zeros(length(remoteHandles.freqVector), 1) + 0;
    [modV2] = zeros(length(remoteHandles.freqVector), 1) + 1;
    pause(1);
end

handles.gammaTP2 = gammaTP2;
handles.gammaTP2PhaseCounts = phaseV;
handles.gammaTP2ModCounts = modV;
handles.reverseT = reverseT;
handles.reverseTPhaseCounts = phaseV2;
handles.reverseTModCounts = modV2;
if (remoteHandles.DebugMode ==0)
    [gammaTP1, phaseV3, modV3,forwardT,phaseV4,modV4] = acquireData(remoteHandles,'FORDWARD');
else
    [gammaTP1] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV3] = zeros(length(remoteHandles.freqVector), 1) + 0;
    [modV3] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [forwardT] = zeros(length(remoteHandles.freqVector), 1) + 1;
    [phaseV4] = zeros(length(remoteHandles.freqVector), 1) + 0;
    [modV4] = zeros(length(remoteHandles.freqVector), 1) + 1;
    pause(1);
end

handles.gammaTP1 = gammaTP1;
handles.gammaTP1PhaseCounts = phaseV3;
handles.gammaTP1ModCounts = modV3;
handles.forwardT = forwardT;
handles.forwardTPhaseCounts = phaseV4;
handles.forwardTModCounts = modV4;
freqOSM = remoteHandles.freqVector;
frecs=reshape(freqOSM,length(freqOSM),1);
creaSxP([frecs,modV3,phaseV3,modV4,phaseV4,modV2,phaseV2,modV,phaseV],'Trough Crudo','.');
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
if(~isempty(handles.gammaShortP1) && ~isempty(handles.gammaOpenP1) && ~isempty(handles.gammaMatchP1) && ~isempty(handles.gammaShortP2) && ~isempty(handles.gammaOpenP2) && ~isempty(handles.gammaMatchP2) )% terminar de poner todos los vectores de calibracion
    set(handles.doneCal, 'Enable', 'on');
end
guidata(hObject, handles);
