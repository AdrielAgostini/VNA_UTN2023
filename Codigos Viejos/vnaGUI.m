function varargout = vnaGUI(varargin)
% VNAGUI M-file for vnagui.fig
%      VNAGUI, by itself, creates a new VNAGUI or raises the existing
%      singleton*.
%
%      H = VNAGUI returns the handle to a new VNAGUI or the handle to
%      the existing singleton*.
%v
%      VNAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VNAGUI.M with the given input arguments.
%
%      VNAGUI('Property','Value',...) creates a new VNAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vnaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vnaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help vnagui

% Last Modified by GUIDE v2.5 16-Oct-2023 04:13:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vnaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @vnaGUI_OutputFcn, ...
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


% --- Executes just before vnagui is made visible.
function vnaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to vnagui (see VARARGIN)

% Choose default command line output for vnagui
handles.output = hObject;
axes(handles.Logo);
logo = imread('logo.png','BackgroundColor', get(0, 'DefaultUIControlBackgroundColor'));%,'BackgroundColor', [1 1 1]);
image(logo)
axis off
axis image
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vnagui wait for user response (see UIRESUME)
% uiwait(handles.vnagui);


% --- Outputs from this function are returned to the command line.
function varargout = vnaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Calibrate.
function Calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to Calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(strcmp(get(handles.Acquire,'Enable'), 'on'))
    answer = questdlg('Ya hay una calibraciÃ³n previa. Volver a calibrar la eliminarÃ¡. Borrar?', 'Borrar calibraciÃ³n previa?', 'Borrar y Recalibrar', 'Cancelar', 'Cancelar');
    if(strcmp(answer,'Cancelar'))
        return;
    end
end
minFreq = str2num(get(handles.minFreq,'String')) * 10^(get(handles.minScale,'Value') * 3);
maxFreq = str2num(get(handles.maxFreq,'String')) * 10^(get(handles.maxScale,'Value') * 3);
sampleNum = str2num(get(handles.sampleNum,'String'));

switch (handles.currentSampleType)
    case 0
        freqVector = linspace(minFreq,maxFreq,sampleNum);
    case 1
        freqVector = logspace(log10(minFreq),log10(maxFreq),sampleNum);
    case 2
%         h = findobj('Tag','segmentos');         %Leo info desde segmentos
%         fig2Data = guidata(h);              
%       freqVector = fig2Data.freqVector_seg;
        freqVector = handles.freqVector;
        %close(segmentos);                       %Cierro la otra ventana
end
 handles.freqVector = freqVector;
% waitfor(warndlg('Colocar el Open', 'CalibraciÃ³n'));
% gammaOpen = acquireData(handles);%zeros(length(freqVector), 1) + 1;%acquireData(handles);
% waitfor(warndlg('Colocar el Short', 'CalibraciÃ³n'));
% gammaShort = acquireData(handles);%zeros(length(freqVector), 1) - 1;%acquireData(handles);
% waitfor(warndlg('Colocar el Match', 'CalibraciÃ³n'));
% gammaMatch = acquireData(handles);%zeros(length(freqVector), 1);%acquireData(handles);
cal_handle = calibrate;
remoteData.DebugMode = handles.DebugMode;
remoteData.freqVector = freqVector;
remoteData.v = handles.v;
remoteData.Ard = handles.Ard;
remoteData.backHandle = hObject;
setappdata(hObject,'calibrationOutput', []); % limpio la memoria
setappdata(cal_handle,'remoteData',remoteData);
set(handles.vnagui, 'Visible', 'on');
waitfor(cal_handle);
set(handles.vnagui, 'Visible', 'on');
calibrationOutput = getappdata(hObject,'calibrationOutput');
if(~isempty(calibrationOutput))
    handles.gammaOpenP1 = calibrationOutput.gammaOpenP1;
    handles.gammaShortP1 = calibrationOutput.gammaShortP1;
    handles.gammaMatchP1 = calibrationOutput.gammaMatchP1;
    handles.openOffsetP1 = calibrationOutput.openOffsetP1;
    handles.shortOffsetP1 = calibrationOutput.shortOffsetP1;
    handles.gammaOpenP2 = calibrationOutput.gammaOpenP2;
    handles.gammaShortP2 = calibrationOutput.gammaShortP2;
    handles.gammaMatchP2 = calibrationOutput.gammaMatchP2;
    handles.openOffsetP2 = calibrationOutput.openOffsetP2;
    handles.shortOffsetP2 = calibrationOutput.shortOffsetP2;
    handles.gammaTP1 = calibrationOutput.gammaTP1;
    handles.gammaTP2 = calibrationOutput.gammaTP2;
    handles.forwardT = calibrationOutput.forwardT;
    handles.reverseT = calibrationOutput.reverseT;
    % Cargo la calibraciÃ³n en la memoria de mediciones
    i = handles.currentMeasurmentIndex;
    handles.readyVNAList{i} = 1;
    handles.minScaleList{i} = get(handles.minScale, 'Value');
    handles.maxScaleList{i} = get(handles.maxScale, 'Value');
    handles.sampleTypeList{i} = handles.currentSampleType;
    handles.freqVectorList{i} = freqVector;
    handles.gammaOpenListP1{i} = calibrationOutput.gammaOpenP1;
    handles.gammaShortListP1{i} = calibrationOutput.gammaShortP1;
    handles.gammaMatchListP1{i} = calibrationOutput.gammaMatchP1;
    handles.openOffsetListP1{i} = calibrationOutput.openOffsetP1;
    handles.shortOffsetListP1{i} = calibrationOutput.shortOffsetP1;
    handles.gammaOpenListP2{i} = calibrationOutput.gammaOpenP2;
    handles.gammaShortListP2{i} = calibrationOutput.gammaShortP2;
    handles.gammaMatchListP2{i} = calibrationOutput.gammaMatchP2;
    handles.openOffsetListP2{i} = calibrationOutput.openOffsetP2;
    handles.shortOffsetListP2{i} = calibrationOutput.shortOffsetP2;
    handles.gammaTP1List{i} = calibrationOutput.gammaTP1;
    handles.gammaTP2List{i} = calibrationOutput.gammaTP2;
    handles.forwardTList{i} = calibrationOutput.forwardT;
    handles.reverserTList{i} = calibrationOutput.reverseT;
    set(handles.Acquire,'Enable', 'on');
    guidata(hObject,handles);
end

% --- Executes on button press in Acquire.
function Acquire_Callback(hObject, eventdata, handles)
% hObject    handle to Acquire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.readyVNAList{handles.currentMeasurmentIndex} == 1)
    freqVector = handles.freqVector;
    set(handles.Calibrate,'Enable', 'off');
    set(handles.SmithPlot,'Enable', 'off');
    set(handles.BodePlot,'Enable', 'off');
    set(handles.RealPlot, 'Enable', 'off');
    set(handles.Export,'Enable', 'off');
    set(handles.Import,'Enable', 'off');
    set(handles.NewM,'Enable', 'off');
    set(handles.DeleteM,'Enable', 'off');
    set(handles.RenameM,'Enable', 'off');
    set(handles.Acquire, 'String', 'Espere');
    if (handles.DebugMode ==0)
         phase21V = 0;
         mod21V = 0;
         phase11V = 0;
         mod11V = 0;
         [S11_M, phase11V, mod11V,S21_M,phase21V,mod21V] =  acquireData(handles,'FORDWARD');  
       % gammaC = gammaCorrect(gammaM, handles.gammaOpen, handles.gammaShort, handles.gammaMatch, freqVector,handles.openOffset, handles.shortOffset);
        %OJO ACÃ� 
       % gammaC = smooth(real(gammaC),0.1,'rloess') +1i*smooth(imag(gammaC),0.1,'rloess');
         phase12V = 0;
         mod12V = 0;
         phase22V = 0;
         mod22V = 0;
         [S12_M, phase12V, mod12V,S22_M,phase22V,mod22V] =  acquireData(handles,'REVERSE');  
    else
        [S11_M] = zeros(length(handles.freqVector), 1) + 1;
        [S21_M] = zeros(length(handles.freqVector), 1) + 1;
        [S22_M] = zeros(length(handles.freqVector), 1) + 1;
        [S12_M] = zeros(length(handles.freqVector), 1) + 1;
        [phase11V] = zeros(length(handles.freqVector), 1) + 1;
        [mod11V] = zeros(length(handles.freqVector), 1) + 1;
        [phase12V] = zeros(length(handles.freqVector), 1) + 1;
        [mod12V] = zeros(length(handles.freqVector), 1) + 1;
        [phase21V] = zeros(length(handles.freqVector), 1) + 1;
        [mod21V] = zeros(length(handles.freqVector), 1) + 1;
        [phase22V] = zeros(length(handles.freqVector), 1) + 1;
        [mod22V] = zeros(length(handles.freqVector), 1) + 1;
        %gammaC = zeros(length(handles.freqVector), 1) + 1;
        pause(1);
    end

    [file, path] = uiputfile('calibracion.mat','Exportar Medicion'); %Prompt para guardar archivo
    if (path>0) 
    handles.S11_M = S11_M;
    handles.S12_M = S12_M;
    handles.S21_M = S21_M;
    handles.S22_M = S22_M;
    handles.phase11V = phase11V;
    handles.mod11V = mod11V;
    handles.phase12V = phase12V;
    handles.mod12V = mod12V;
    handles.phase21V = phase21V;
    handles.mod21V = mod21V;
    handles.phase22V = phase22V;
    handles.mod22V = mod22V;
    set(handles.Acquire, 'String', 'Adquirir');
    set(handles.Calibrate,'Enable', 'on');
    set(handles.SmithPlot,'Enable', 'on');
    set(handles.BodePlot,'Enable', 'on');
    set(handles.RealPlot, 'Enable', 'on');
    set(handles.Export,'Enable', 'on');
    set(handles.Import,'Enable', 'on');
    set(handles.NewM,'Enable', 'on');
    set(handles.DeleteM,'Enable', 'on');
    set(handles.RenameM,'Enable', 'on');
    frecs=reshape(freqVector,length(freqVector),1);
    creaSxP([frecs,mod11V,phase11V,mod21V,phase21V,mod12V,phase12V,mod22V,phase22V],'Medicion Crudo','.');
    sound(handles.doneSound,handles.doneFs);
    save([path file],'freqVector','S11_M','S21_M','S12_M', 'S22_M');
    guidata(hObject,handles);
    end
end


function minFreq_Callback(hObject, eventdata, handles)
% hObject    handle to minFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minFreq as text
%        str2double(get(hObject,'String')) returns contents of minFreq as a double


% --- Executes during object creation, after setting all properties.
function minFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxFreq_Callback(hObject, eventdata, handles)
% hObject    handle to maxFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxFreq as text
%        str2double(get(hObject,'String')) returns contents of maxFreq as a double


% --- Executes during object creation, after setting all properties.
function maxFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Export.
function Export_Callback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    freqVector = handles.freqVector;
    n = length(freqVector);
	r = rfdata.data;
    r.Freq = freqVector;
%     if handles.currentGraph == 0
%         S11 = reshape(handles.gammaC, 1,1,n);
%     else
%         S11 = reshape(handles.gammaM, 1,1,n);
%     end
%     r.S_Parameters = S11;
    r.Z0 = 50;
    [file, path] = uiputfile('output.s2p','Exportar MediciÃ³n'); %Prompt para guardar archivo
    if (path>0)                     %Verificacion de que no se eligio CANCEL
        r.S_Parameters = reshape([handles.S11_M:handles.S12M:handles.S21_M:handles.S22_M],2,2,n);
        write(r,[path file '_crudo'],'MA','HZ','%6E','%6E');
       % r.S_Parameters = reshape(handles.gammaM, 1,1,n);
       % write(r,[path file '_sin_corregir'],'MA','HZ','%6E','%6E');
       % newfile = regexprep(file,'.s1p','.mat');
       % phaseV =handles.phaseV;
       % modV =handles.modV;
       % save([path newfile], 'freqVector','modV', 'phaseV');
    end   

% --- Executes on button press in SmithPlot.
function SmithPlot_Callback(hObject, eventdata, handles)
% hObject    handle to SmithPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    figure;
    graphTitle = get(handles.CurrentM,'String');
    graphTitle = graphTitle{handles.currentMeasurmentIndex};
    switch handles.currentGraph
        case 0
            [line, hsm] = smithchart(handles.gammaC);
            line.Marker = '.';
            line.Color = 'b'
        case 1
            [line, hsm] = smithchart(handles.gammaM);
            line.Marker = '.';
            line.Color = 'r'
        case 2
            [line, hsm] = smithchart(handles.gammaC);
            line.Marker = '.';
            line.Color = 'b'
            hold on;
            [line, hsm] = smithchart(handles.gammaM);
            line.Marker = '.';
            line.Color = 'r'
            hold off;
            legend('Corregido','Sin Corregir','Location','northeastoutside')
    end
    %tÃ­tulo y cambio de posiciÃ³n
    t = title(graphTitle);
    pos = get(t,'Position');
    pos(1) = pos(1) + 0.3;
    set(t,'Position', pos);
            
% --- Executes on button press in BodePlot.
function BodePlot_Callback(hObject, eventdata, handles)
% hObject    handle to BodePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
figureName = get(handles.CurrentM,'String');
figureName = figureName{handles.currentMeasurmentIndex};
subplot(2,1,1);
switch (handles.currentGraph)
    case 0
        plot(handles.freqVector, 20*log10(abs(handles.gammaC)));
        title(['MÃ³dulo de ' figureName]);
        xlabel('Frecuencia (Hz)');
        ylabel('MÃ³dulo (dB)');
        subplot(2,1,2);
        plot(handles.freqVector, (180/pi).*angle(handles.gammaC));
    case 1
        plot(handles.freqVector, 20*log10(abs(handles.gammaM)));
        title(['MÃ³dulo de ' figureName]);
        xlabel('Frecuencia (Hz)');
        ylabel('MÃ³dulo (dB)');
        subplot(2,1,2);
        plot(handles.freqVector, (180/pi).*angle(handles.gammaM));
    case 2
        plot(handles.freqVector, 20*log10(abs(handles.gammaC)));
        title(['MÃ³dulo de ' figureName]);
        xlabel('Frecuencia (Hz)');
        ylabel('MÃ³dulo (dB)');
        hold on;
        plot(handles.freqVector, 20*log10(abs(handles.gammaM)));
        hold off;
        legend('Corregido','Sin Corregir','Location','northeast');
        subplot(2,1,2);
        plot(handles.freqVector, (180/pi).*angle(handles.gammaC));
        hold on;
        plot(handles.freqVector, (180/pi).*angle(handles.gammaM));
        hold off;
        legend('Corregido','Sin Corregir','Location','northeast');
end
subplot(2,1,2);
title(['Fase de ' figureName]);
xlabel('Frecuencia (Hz)');
ylabel('Fase (Âº)');

%%%%%%%%% BORRAR EN LA VERSION DEFINITIVA %%%%%%%%%%%%%%%
% figure
% subplot(2,1,1);
% switch (handles.currentGraph)
%     case 0
%         semilogx(handles.freqVector, 20*log10(handles.modV));
%         title(['CUENTAS MÃ³dulo de ' figureName]);
%         xlabel('Frecuencia (Hz)');
%         ylabel('MÃ³dulo (dB)');
%         subplot(2,1,2);
%         semilogx(handles.freqVector, handles.phaseV);
%     case 1
%          semilogx(handles.freqVector, 20*log10(handles.modV));
%         title(['CUENTAS MÃ³dulo de ' figureName]);
%         xlabel('Frecuencia (Hz)');
%         ylabel('MÃ³dulo (dB)');
%         subplot(2,1,2);
%         semilogx(handles.freqVector, handles.phaseV);
%     case 2
%         semilogx(handles.freqVector, 20*log10(abs(handles.gammaC)));
%         title(['MÃ³dulo de ' figureName]);
%         xlabel('Frecuencia (Hz)');
%         ylabel('MÃ³dulo (dB)');
%         hold on;
%         semilogx(handles.freqVector, 20*log10(abs(handles.gammaM)));
%         hold off;
%         legend('Corregido','Sin Corregir','Location','northeast');
%         subplot(2,1,2);
%         semilogx(handles.freqVector, (180/pi).*angle(handles.gammaC));
%         hold on;
%         semilogx(handles.freqVector, (180/pi).*angle(handles.gammaM));
%         hold off;
%         legend('Corregido','Sin Corregir','Location','northeast');
% end
% subplot(2,1,2);
% title(['Fase de ' figureName]);
% xlabel('Frecuencia (Hz)');
% ylabel('Fase (Âº)');
% modV = handles.modV;
% phaseV = handles.phaseV;
% [file, path] = uiputfile('output.mat','Exportar MediciÃ³n'); %Prompt para guardar archivo
% if (path>0)    
%     save([path file], 'modV', 'phaseV');
% end

%%% TERMINAR DE BORRAR ACA


% --- Executes on selection change in minScale.
function minScale_Callback(hObject, eventdata, handles)
% hObject    handle to minScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns minScale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from minScale


% --- Executes during object creation, after setting all properties.
function minScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in maxScale.
function maxScale_Callback(hObject, eventdata, handles)
% hObject    handle to maxScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns maxScale contents as cell array
%        contents{get(hObject,'Value')} returns selected item from maxScale


% --- Executes during object creation, after setting all properties.
function maxScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sampleNum_Callback(hObject, eventdata, handles)
% hObject    handle to sampleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleNum as text
%        str2double(get(hObject,'String')) returns contents of sampleNum as a double


% --- Executes during object creation, after setting all properties.
function sampleNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Connect.
function Connect_Callback(hObject, eventdata, handles)
% hObject    handle to Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if (handles.configuredFlag == 0)
        v = 0;
        Ard = 0;
        % ConexiÃ³n Arduino
        Port  = 'COM3'; %Poner el COM a donde se conecta el Arduino NANO
        Board = 'Nano3';
        V_ref = 1.8;
        Avg   = 0; %pin para lectura del modulo
        Phs   = 1; %pin para lectura de la fase

        AN_REF_DEF = 'default';
        AN_REF_EXT = 'external';
        
        if (handles.DebugMode == 0)
            disp('Conectando con Dispositivo Arduino...');
            %borro posibles conexiones que estuvieran en el puerto
            delete(instrfind({'Port'},{Port}));
            % comentar las 2 siguientes para probar sin dispositivos
            %Ard=arduino(Port);
            Ard=arduino(Port,Board,'AnalogReferenceMode','external','AnalogReference',V_ref);
            configurePin(Ard,'D12','DigitalOutput');
            disp('Arduino conectado correctamente.');
            disp('Conectando con Generador Agilent...');
           % pinMode(Ard,12,'output');
            %pinMode(Ard,11,'output');
          %  pinMode(Ard,13,'output');
            %analogReference(Ard, AN_REF_DEF); %Cambiar AN_REF_EXT
            v = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0957::0x2018::01152719::INSTR', 'Tag', '');
if isempty(v)
    v = visa('AGILENT', 'USB0::0x0957::0x2018::01152719::0::INSTR');
    
else
    fclose(v);
    v = v(1)
end
fopen(v);
            % ConexiÃ³n Generador
            % comentar las 2 siguientes para probar sin dispositivos
            
            %v = visa('AGILENT', 'USB0::0x0957::0x2018::01152719::0::INSTR');
            %fopen(v);
        else            
            v = 1; % Eliminar en versiÃ³n final.
            Ard = 1; % Eliminar en versiÃ³n final.
        end
        if (v == 0)
            warndlg('No se pudo conectar al generador. Revise conexiÃ³n y vuelva a intentar.', 'Error de ConexiÃ³n!');
            return;
        end
        
        if (Ard == 0)
            warndlg('No se pudo conectar al adquisidor. Revise conexiÃ³n y vuelva a intentar.', 'Error de ConexiÃ³n!');
            return;
        end
        set(handles.Calibrate, 'Enable', 'on');
        set(handles.NoCorrection, 'Enable', 'on');
        %set(handles.Acquire, 'Enable', 'on');
        set(handles.maxFreq, 'Enable', 'on');
        set(handles.minFreq, 'Enable', 'on');
        set(handles.sampleNum, 'Enable', 'on');
        set(handles.minScale, 'Enable', 'on');
        set(handles.maxScale, 'Enable', 'on');
        set(handles.rLin, 'Enable', 'on');
        set(handles.rLog, 'Enable', 'on');
        set(handles.rSeg, 'Enable', 'on');
        set(handles.CurrentM, 'Enable', 'on');
        set(handles.NewM, 'Enable', 'on');
        set(handles.DeleteM, 'Enable', 'on');
        set(handles.RenameM, 'Enable', 'on');
        set(handles.rCorrect, 'Enable', 'on');
        set(handles.rNoCorrect, 'Enable', 'on');
        set(handles.rBoth, 'Enable', 'on');
        set(handles.Import, 'Enable', 'on');
        set(handles.Connect, 'String', 'Desconectar');
        handles.v = v;
        handles.Ard = Ard;
        fprintf(v,':SYST:DISP GREEN'); %Cambio pantalla de color
        disp('Generador Agilent conectado correctamente.');
        handles.configuredFlag = 1;
    else
        v = handles.v;
        Ard = handles.Ard;
        if (handles.DebugMode == 0)            
            fprintf(v,':SYST:DISP BLUE'); %Cambio pantalla de color
            % comentar las 3 siguientes para probar sin dispositivos

            fclose(v);
            delete(v);
            %delete(Ard);
        end
        set(handles.Calibrate, 'Enable', 'off');
        set(handles.Acquire, 'Enable', 'off');
        set(handles.NoCorrection, 'Enable', 'off');
        set(handles.maxFreq, 'Enable', 'off');
        set(handles.minFreq, 'Enable', 'off');
        set(handles.sampleNum, 'Enable', 'off');
        set(handles.minScale, 'Enable', 'off');
        set(handles.maxScale, 'Enable', 'off');
        set(handles.rLin, 'Enable', 'off');
        set(handles.rLog, 'Enable', 'off');
        set(handles.rSeg, 'Enable', 'off');
        set(handles.BodePlot, 'Enable', 'off');
        set(handles.RealPlot, 'Enable', 'off');
        set(handles.SmithPlot, 'Enable', 'off');
        set(handles.Export, 'Enable', 'off');
        set(handles.CurrentM, 'Enable', 'off');
        set(handles.NewM, 'Enable', 'off');
        set(handles.RenameM, 'Enable', 'off');
        set(handles.DeleteM, 'Enable', 'off');
        set(handles.rCorrect, 'Enable', 'off');
        set(handles.rNoCorrect, 'Enable', 'off');
        set(handles.rBoth, 'Enable', 'off');
        set(handles.Connect, 'String', 'Conectar');
        handles.v = 0;
        handles.Ard = 0;
        handles.configuredFlag = 0;
    end
    guidata(hObject, handles);


% --- Executes on button press in SegmentEditor.
function SegmentEditor_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
%p
%window 2
 
%seg_handles = segmentos;
setappdata (0, 'freqseg', handles.freqVector);
setappdata (0, 'lines', handles.lines);
setappdata (0, 'cant', handles.cant);
seg_handles = segmentos;
%setappdata (seg_handles, 'main_handle', 0);
set(handles.vnagui, 'Visible', 'off');
uiwait(seg_handles);
handles.freqVector = getappdata(vnaGUI,'freqseg');
handles.lines = getappdata(vnaGUI,'lines');
handles.cant = getappdata(vnaGUI,'cant');
set(handles.vnagui, 'Visible', 'on');
guidata(hObject, handles);


% --- Executes on button press in rSeg.
function rSeg_Callback(hObject, eventdata, handles)
% hObject    handle to rSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rSeg
    % Valor de handles.currentSampleType
    % 0: Lineal
    % 1: LogarÃ­tmico
    % 2: Segmentado
    if (handles.currentSampleType ~= 2)
        handles.currentSampleType = 2;
        set(handles.Acquire,'Enable', 'off');
        set(handles.maxFreq,'Enable', 'off');
        set(handles.maxScale,'Enable', 'off');
        set(handles.minFreq,'Enable', 'off');
        set(handles.minScale,'Enable', 'off');
        set(handles.sampleNum,'Enable', 'off');
        set(handles.Acquire,'Enable', 'off');
        set(handles.SegmentEditor,'Enable', 'on');
        guidata(hObject,handles);
    end

% --- Executes during object creation, after setting all properties.
function vnagui_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vnagui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.DebugMode = 0; % 1 para usar sin conectar a los dispositivos
handles.configuredFlag = 0;
handles.v = 0;
handles.Ard = 0;
handles.currentSampleType = 1; %LogarÃ­tmico
handles.currentGraph = 0; %Gamma Corregido
handles.currentMeasurmentIndex = 5; %Las primeras 4 estÃ¡n reservadas
handles.lines = [];
handles.freqVector = [];
handles.cant = 1;

load('demo.mat'); %cargo valores de un archivo Demo: freq, S11o, S11s, S11l, S11m, S11f
freq = freq./1000; %Bajo el valor porque los demos conseguidos son muy altos
% Creo todos los datos para las 4 Default
freqVector = linspace(10e3,3e9,100);
open = zeros(length(freq), 1) + 1;
short = zeros(length(freq), 1) - 1;
match = zeros(length(freq), 1);
handles.gammaMList{1} = S11o;
handles.gammaCList{1} = open;
handles.gammaOpenList{1} = 0
handles.gammaShortList{1} = 0;
handles.gammaMatchList{1} = 0;
handles.freqVectorList{1} = freq;
handles.maxScaleList{1} = 2;
handles.minScaleList{1} = 1;
handles.sampleTypeList{1} = 0;
handles.readyVNAList{1} = 0;
handles.gammaMList{2} = S11s;
handles.gammaCList{2} = short;
handles.gammaOpenList{2} = 0;
handles.gammaShortList{2} = 0;
handles.gammaMatchList{2} = 0;
handles.freqVectorList{2} = freq;
handles.maxScaleList{2} = 2;
handles.minScaleList{2} = 1;
handles.sampleTypeList{2} = 0;
handles.readyVNAList{2} = 0;
handles.gammaMList{3} = S11l;
handles.gammaCList{3} = match;
handles.gammaOpenList{3} = 0;
handles.gammaShortList{3} = 0;
handles.gammaMatchList{3} = 0;
handles.freqVectorList{3} = freq;
handles.maxScaleList{3} = 2;
handles.minScaleList{3} = 1;
handles.sampleTypeList{3} = 0;
handles.readyVNAList{3} = 0;

% MediciÃ³n Demo
handles.gammaMList{4} = S11m;
handles.gammaCList{4} = S11f;
handles.gammaOpenList{4} = 0;
handles.gammaShortList{4} = 0;
handles.gammaMatchList{4} = 0;
handles.freqVectorList{4} = freq;
handles.maxScaleList{4} = 2;
handles.minScaleList{4} = 1;
handles.sampleTypeList{4} = 0;
handles.readyVNAList{4} = 0;

% Importo Audio y logo
[doneSound,doneFs] = audioread('alert.mp3');
handles.doneSound = doneSound;
handles.doneFs = doneFs;

% Preparo primer medicion
handles.gammaMList{5} = 0;
handles.gammaCList{5} = 0;
handles.gammaOpenList{5} = 0;
handles.gammaShortList{5} = 0;
handles.gammaMatchList{5} = 0;
handles.freqVectorList{5} = 0;
handles.maxScaleList{5} = 3;
handles.minScaleList{5} = 1;
handles.sampleTypeList{5} = 1;
handles.readyVNAList{5} = 0;



guidata(hObject, handles);


% --- Executes when user attempts to close vnagui.
function vnagui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to vnagui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(handles.configuredFlag == 1 && handles.v ~= 1 && handles.Ard ~= 1 )
        v = handles.v;
        Ard = handles.Ard;
        fprintf(v,':SYST:DISP BLUE'); %Cambio pantalla de color
        % comentar las 3 siguientes para probar sin dispositivos
        fclose(v);
        delete(v);
        delete(Ard);
    end
    delete(hObject);


% --- Executes on button press in rLin.
function rLin_Callback(hObject, eventdata, handles)
% hObject    handle to rLin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
% Hint: get(hObject,'Value') returns toggle state of rLin
    % Valor de handles.currentSampleType
    % 0: Lineal
    % 1: LogarÃ­tmico
    % 2: Segmentado
    if (handles.currentSampleType ~= 0)
        if (handles.currentSampleType == 2) %activaciÃ³n de panel de frecuencias
            set(handles.Acquire,'Enable', 'on');
            set(handles.maxFreq,'Enable', 'on');
            set(handles.maxScale,'Enable', 'on');
            set(handles.minFreq,'Enable', 'on');
            set(handles.minScale,'Enable', 'on');
            set(handles.sampleNum,'Enable', 'on');
            set(handles.SegmentEditor,'Enable', 'off');
        end
        handles.currentSampleType = 0;
        set(handles.Acquire,'Enable', 'off');
        guidata(hObject, handles);
    end
        

% --- Executes on button press in NoCorrection.
function NoCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to NoCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    minFreq = str2num(get(handles.minFreq,'String')) * 10^(get(handles.minScale,'Value') * 3);
    maxFreq = str2num(get(handles.maxFreq,'String')) * 10^(get(handles.maxScale,'Value') * 3);
    sampleNum = str2num(get(handles.sampleNum,'String'));

    switch (handles.currentSampleType)
        case 0
            freqVector = linspace(minFreq,maxFreq,sampleNum);
        case 1
            freqVector = logspace(log10(minFreq),log10(maxFreq),sampleNum);
        case 3
            %TODO
    end
    handles.freqVector = freqVector;
    [gamma, phaseV, modV] = acquireData(handles);
   %[gamma] = acquireData(handles);
    handles.gammaM = gamma;
    handles.phaseV = phaseV;
    handles.modV = modV;
    handles.gammaC = 0;
    set(handles.SmithPlot, 'Enable', 'on');
    set(handles.BodePlot, 'Enable', 'on');
    set(handles.RealPlot, 'Enable', 'on');
    set(handles.Export, 'Enable', 'on');
    guidata(hObject, handles);


% --- Executes on button press in Import.
function Import_Callback(hObject, eventdata, handles)
% hObject    handle to Import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.s1p','Elige Archivo *.s1p');  % Genera cuadro de dialogo para buscar archivo *.s1p
if PathName > 0
    h = read (rfdata.data,[PathName FileName]);
    S11 = h.S_parameters;
    freq = h.Freq;
    n = length(freq);
    S11 = reshape(S11,n,1);
    measurmentList = get(handles.CurrentM,'String');%Obtiene Datos de Listbox
    i = length(measurmentList)+1 ;                  %Obtiene nueva posicion a agregar
    measurmentList{i} = FileName;                   %Agrega nueva mediciÃ³n
    set(handles.CurrentM,'String',measurmentList);  
    set(handles.CurrentM, 'Value', i);
    set(handles.SmithPlot, 'Enable', 'on');
    set(handles.BodePlot, 'Enable', 'on');
    set(handles.RealPlot, 'Enable', 'on');
    set(handles.Export, 'Enable', 'on');
    handles.currentMeasurmentIndex = i;
    handles.gammaMList{i} = S11;					%TODO: Agrega el mismo dato a Corregido y Sin corregir
    handles.gammaCList{i} = S11;
    handles.gammaOpenList{i} = 0;
    handles.gammaShortList{i} = 0;
    handles.gammaMatchList{i} = 0;
    handles.freqVectorList{i} = freq;
    handles.maxScaleList{i} = 2;
    handles.minScaleList{i} = 1;
    handles.sampleTypeList{i} = 0;
    handles.readyVNAList{i} = 1;                    % Tiene que estar en 1
     %Agregado
    handles.gammaM = handles.gammaMList{i};
    handles.gammaC = handles.gammaCList{i}; 
    handles.freqVector = handles.freqVectorList{i}; %Agregado
    guidata(hObject, handles);
end

% --- Executes on selection change in CurrentM.
function CurrentM_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CurrentM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CurrentM
i = get(hObject,'Value');
handles.currentMeasurmentIndex = i; %actualizo el Ã­ndice global
% datos no default
if (i > 4)
    set(handles.DeleteM,'Enable','on');
    set(handles.RenameM,'Enable','on');
    switch (handles.sampleTypeList{i})
        case 0
            set(handles.rLin,'Value',1);
        case 1
            set(handles.rLog,'Value',1);
        case 2
            set(handles.rSeg,'Value',1);
    end
    % ya fue calibrado
    if(handles.readyVNAList{i} == 1)
        handles.gammaOpen = handles.gammaOpenList{i};
        handles.gammaShort = handles.gammaShortList{i};
        handles.gammaMatch = handles.gammaMatchList{i};
        handles.openOffset = handles.openOffsetList{i};
        handles.shortOffset = handles.shortOffsetList{i};
        handles.freqVector = handles.freqVectorList{i};
        set(handles.Calibrate,'Enable', 'on');
        set(handles.Acquire,'Enable', 'on');
        k = handles.minScaleList{i};
        set(handles.minScale,'Value', k);
        set(handles.minFreq,'String',num2str(handles.freqVector(1)/10^(3*k)));
        k = handles.maxScaleList{i};
        set(handles.maxScale,'Value', k);
        set(handles.maxFreq,'String',num2str(handles.freqVector(end)/10^(3*k))); 
        set(handles.sampleNum,'String',num2str(length(handles.freqVector)));
        %ya se hizo alguna mediciÃ³n
        if(handles.gammaMList{i} ~=0)
           handles.gammaM = handles.gammaMList{i};
           handles.gammaC = handles.gammaCList{i};
           handles.freqVector = handles.freqVectorList{i}; %Agregado
           set(handles.SmithPlot,'Enable', 'on');
           set(handles.BodePlot,'Enable', 'on');
           set(handles.RealPlot, 'Enable', 'on');
           set(handles.Export,'Enable', 'on');
           set(handles.Import,'Enable', 'on');
        else
           set(handles.SmithPlot,'Enable', 'off');
           set(handles.BodePlot,'Enable', 'off');
           set(handles.RealPlot, 'Enable', 'off');
           set(handles.Export,'Enable', 'off');
        end
    else
       set(handles.Calibrate,'Enable', 'on');
       set(handles.Acquire,'Enable', 'off');
       set(handles.SmithPlot,'Enable', 'off');
       set(handles.BodePlot,'Enable', 'off');
       set(handles.RealPlot, 'Enable', 'off');
       set(handles.Export,'Enable', 'off');
    end
else
    % datos default
    set(handles.Acquire,'Enable', 'off');
    set(handles.Calibrate,'Enable', 'off');
    set(handles.Import,'Enable', 'on');
    set(handles.Export,'Enable', 'on');
    handles.gammaOpen = handles.gammaOpenList{i};
    handles.gammaShort = handles.gammaShortList{i};
    handles.gammaMatch = handles.gammaMatchList{i};
    handles.freqVector = handles.freqVectorList{i};
    handles.gammaM = handles.gammaMList{i};
    handles.gammaC = handles.gammaCList{i};
    switch (handles.sampleTypeList{i})
        case 0
            set(handles.rLin,'Value',1);
        case 1
            set(handles.rLog,'Value',1);
        case 2
            set(handles.rSeg,'Value',1);
    end
    set(handles.BodePlot,'Enable', 'on');
    set(handles.SmithPlot,'Enable', 'on');
    set(handles.RealPlot, 'Enable', 'on');
    set(handles.DeleteM,'Enable', 'off');
    set(handles.RenameM,'Enable', 'off');
    set(handles.NoCorrection, 'Enable','off');
    k = handles.minScaleList{i};
    set(handles.minScale,'Value', k);
    set(handles.minFreq,'String',num2str(handles.freqVector(1)/10^(3*k)));
    k = handles.maxScaleList{i};
    set(handles.maxScale,'Value', k);
    set(handles.maxFreq,'String',num2str(handles.freqVector(end)/10^(3*k)));
    set(handles.sampleNum,'String',num2str(length(handles.freqVector)));
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function CurrentM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NewM.
function NewM_Callback(hObject, eventdata, handles)
% hObject    handle to NewM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    newName = inputdlg(['Ingrese nombre:'],['Nueva MediciÃ³n...']);
    if (~isempty(newName)) % si no estÃ¡ vacÃ­a o cancelÃ³ 
        measurmentList = get(handles.CurrentM,'String');
        i = length(measurmentList) + 1;
        measurmentList{i} = newName{1}; % agrego nueva mediciÃ³n
        set(handles.CurrentM,'String',measurmentList);
        set(handles.CurrentM, 'Value', i);
        handles.gammaMList{i} = 0;
        handles.gammaCList{i} = 0;
        handles.gammaOpenList{i} = 0;
        handles.gammaShortList{i} = 0;
        handles.gammaMatchList{i} = 0;
        handles.openOffsetList{i} = 0;
        handles.shortOffsetList{i} = 0;
        handles.freqVectorList{i} = 0;
        handles.maxScaleList{i} = 3;
        handles.minScaleList{i} = 1;
        handles.sampleTypeList{i} = 1;
        handles.readyVNAList{i} = 0;
        handles.currentMeasurmentIndex = i;
        set(handles.Acquire, 'Enable', 'off');
        set(handles.minFreq, 'String', '10');
        set(handles.maxFreq, 'String', '3');
        set(handles.sampleNum, 'String', '50');
        set(handles.minScale, 'Value', 1);
        set(handles.maxScale, 'Value', 3);
        set(handles.rLog, 'Value', 1);
        set(handles.SmithPlot, 'Enable', 'off');
        set(handles.BodePlot, 'Enable', 'off');
        set(handles.RealPlot, 'Enable', 'off');
        set(handles.Calibrate, 'Enable', 'on');
        set(handles.DeleteM, 'Enable', 'on');
        set(handles.RenameM, 'Enable', 'on');
        guidata(hObject, handles);
    end

% --- Executes on button press in DeleteM.
function DeleteM_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    d = questdlg('Borrar definitivamente la mediciÃ³n? Este cambio es irreversible.', 'Borrar MediciÃ³n', 'Borrar', 'Cancelar', 'Cancelar');
    if (d == 'Borrar')
       i = handles.currentMeasurmentIndex;
       handles.currentMeasurmentIndex = i - 1; %anterior
       measurmentList = get(handles.CurrentM,'String');
       lastItem = length(measurmentList)
       for n = i:(lastItem - 1)
           measurmentList{n} = measurmentList{n+1};
           handles.gammaMList{n} = handles.gammaMList{n + 1};
           handles.gammaCList{n} = handles.gammaCList{n + 1};
           handles.gammaOpenList{n} = handles.gammaOpenList{n + 1};
           handles.gammaShortList{n} = handles.gammaShortList{n + 1};
           handles.gammaMatchList{n} = handles.gammaMatchList{n + 1};
           handles.freqVectorList{n} = handles.freqVectorList{n + 1};
           handles.maxScaleList{n} =  handles.maxScaleList{n + 1};
           handles.minScaleList{n} = handles.minScaleList{n + 1};
           handles.sampleTypeList{n} = handles.sampleTypeList{n + 1};
           handles.readyVNAList{n} = handles.readyVNAList{n + 1};
       end
       measurmentList(lastItem) = [];
       handles.gammaMList(lastItem) = [];
       handles.gammaCList(lastItem) = [];
       handles.gammaOpenList(lastItem) = [];
       handles.gammaShortList(lastItem) = [];
       handles.gammaMatchList(lastItem) = [];
       handles.freqVectorList(lastItem) = [];
       handles.maxScaleList(lastItem) = [];
       handles.minScaleList(lastItem) = [];
       handles.sampleTypeList(lastItem) = [];
       handles.readyVNAList(lastItem) = [];
       set(handles.CurrentM, 'String', measurmentList);
       i = i - 1 % anterior mediciÃ³n
       set(handles.CurrentM, 'Value', i);
       if (i > 4)
            set(handles.DeleteM,'Enable','on');
            set(handles.RenameM,'Enable','on');
            switch (handles.sampleTypeList{i})
                case 0
                    set(handles.rLin,'Value',1);
                case 1
                    set(handles.rLog,'Value',1);
                case 2
                    set(handles.rSeg,'Value',1);
            end
            % ya fue calibrado
            if(handles.readyVNAList{i} == 1)
                handles.gammaOpen = handles.gammaOpenList{i};
                handles.gammaShort = handles.gammaShortList{i};
                handles.gammaMatch = handles.gammaMatchList{i};
                handles.freqVector = handles.freqVectorList{i};
                set(handles.Calibrate,'Enable', 'on');
                set(handles.Acquire,'Enable', 'on');
                k = handles.minScaleList{i};
                set(handles.minScale,'Value', k);
                set(handles.minFreq,'String',num2str(handles.freqVector(1)/10^(3*k)));
                k = handles.maxScaleList{i};
                set(handles.maxScale,'Value', k);
                set(handles.maxFreq,'String',num2str(handles.freqVector(end)/10^(3*k))); 
                set(handles.sampleNum,'String',num2str(length(handles.freqVector)));
                %ya se hizo alguna mediciÃ³n
                if(handles.gammaMList{i} ~=0)
                   handles.gammaM = handles.gammaMList{i};
                   handles.gammaC = handles.gammaCList{i};
                   set(handles.SmithPlot,'Enable', 'on');
                   set(handles.BodePlot,'Enable', 'on');
                   set(handles.Export,'Enable', 'on');
                   set(handles.Import,'Enable', 'on');
                else
                   set(handles.SmithPlot,'Enable', 'off');
                   set(handles.BodePlot,'Enable', 'off');
                   set(handles.Export,'Enable', 'off');
                end
            else
               set(handles.Calibrate,'Enable', 'on');
               set(handles.Acquire,'Enable', 'off');
               set(handles.SmithPlot,'Enable', 'off');
               set(handles.BodePlot,'Enable', 'off');
               set(handles.Export,'Enable', 'off');
            end
        else
            % datos default
            set(handles.Acquire,'Enable', 'off');
            set(handles.Calibrate,'Enable', 'off');
            set(handles.Import,'Enable', 'off');
            handles.gammaOpen = handles.gammaOpenList{i};
            handles.gammaShort = handles.gammaShortList{i};
            handles.gammaMatch = handles.gammaMatchList{i};
            handles.freqVector = handles.freqVectorList{i};
            handles.gammaM = handles.gammaMList{i};
            handles.gammaC = handles.gammaCList{i};
            switch (handles.sampleTypeList{i})
                case 0
                    set(handles.rLin,'Value',1);
                case 1
                    set(handles.rLog,'Value',1);
                case 2
                    set(handles.rSeg,'Value',1);
            end
            set(handles.BodePlot,'Enable', 'on');
            set(handles.SmithPlot,'Enable', 'on');
            set(handles.DeleteM,'Enable', 'off');
            set(handles.RenameM,'Enable', 'off');
            set(handles.NoCorrection, 'Enable','off');
            k = handles.minScaleList{i};
            set(handles.minScale,'Value', k);
            set(handles.minFreq,'String',num2str(handles.freqVector(1)/10^(3*k)));
            k = handles.maxScaleList{i};
            set(handles.maxScale,'Value', k);
            set(handles.maxFreq,'String',num2str(handles.freqVector(end)/10^(3*k)));
            set(handles.sampleNum,'String',num2str(length(handles.freqVector)));
       end
       guidata(hObject, handles);
    end

% --- Executes on button press in rLog.
function rLog_Callback(hObject, eventdata, handles)
% hObject    handle to rLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rLog
    % Valor de handles.currentSampleType
    % 0: Lineal
    % 1: LogarÃ­tmico
    % 2: Segmentado
    if (handles.currentSampleType ~= 1)
        if (handles.currentSampleType == 2) %activaciÃ³n de panel de frecuencias
            set(handles.Acquire,'Enable', 'on');
            set(handles.maxFreq,'Enable', 'on');
            set(handles.maxScale,'Enable', 'on');
            set(handles.minFreq,'Enable', 'on');
            set(handles.minScale,'Enable', 'on');
            set(handles.sampleNum,'Enable', 'on');
            set(handles.SegmentEditor,'Enable', 'off');
        end
        handles.currentSampleType = 1;
        set(handles.Acquire,'Enable', 'off');
        guidata(hObject,handles);
    end


% --- Executes on button press in rCorrect.
function rCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to rCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rCorrect
 % Valor de handles.currentGraph
    % 0: Corregido
    % 1: Sin Corregir
    % 2: Ambos
    handles.currentGraph = 0;
    set(handles.Export,'Enable', 'on');
    guidata(hObject,handles);


% --- Executes on button press in rNoCorrect.
function rNoCorrect_Callback(hObject, eventdata, handles)
% hObject    handle to rNoCorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rNoCorrect
% Valor de handles.currentGraph
    % 0: Corregido
    % 1: Sin Corregir
    % 2: Ambos
    handles.currentGraph = 1;
    set(handles.Export,'Enable', 'on');
    guidata(hObject,handles);


% --- Executes on button press in rBoth.
function rBoth_Callback(hObject, eventdata, handles)
% hObject    handle to rBoth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rBoth
% Valor de handles.currentGraph
    % 0: Corregido
    % 1: Sin Corregir
    % 2: Ambos
    handles.currentGraph = 2;
    set(handles.Export,'Enable', 'off');
    guidata(hObject,handles);


% --- Executes on button press in RenameM.
function RenameM_Callback(hObject, eventdata, handles)
% hObject    handle to RenameM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    measurmentNames = get(handles.CurrentM,'String')
    oldName = measurmentNames{handles.currentMeasurmentIndex}
    newName = inputdlg(['Ingrese nuevo nombre para "' oldName '":'],['Cambiar Nombre...'])
    if (~isempty(newName)) % si no estÃ¡ vacÃ­a o cancelÃ³ 
        measurmentNames{handles.currentMeasurmentIndex} = newName{1}
        set(handles.CurrentM,'String',measurmentNames)
    end


% --- Executes on button press in RealPlot.
function RealPlot_Callback(hObject, eventdata, handles)
% hObject    handle to RealPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
figureName = get(handles.CurrentM,'String');
figureName = figureName{handles.currentMeasurmentIndex};
subplot(2,1,1);
switch (handles.currentGraph)
    case 0
        plot(handles.freqVector, real(handles.gammaC));
        title(['Parte Real de ' figureName]);
        xlabel('Frecuencia (Hz)');
        ylabel('Re');
        subplot(2,1,2);
        plot(handles.freqVector, imag(handles.gammaC));
    case 1
        plot(handles.freqVector, real(handles.gammaM));
        title(['Parte Real de ' figureName]);
        xlabel('Frecuencia (Hz)');
        ylabel('Re');
        subplot(2,1,2);
        plot(handles.freqVector, imag(handles.gammaM));
    case 2
        plot(handles.freqVector, real(handles.gammaC));
        title(['Parte Real de ' figureName]);
        xlabel('Frecuencia (Hz)');
        ylabel('Re');
        hold on;
        plot(handles.freqVector, real(handles.gammaM));
        hold off;
        legend('Corregido','Sin Corregir','Location','northeast');
        subplot(2,1,2);
        plot(handles.freqVector, imag(handles.gammaC));
        hold on;
        plot(handles.freqVector, imag(handles.gammaM));
        hold off;
        legend('Corregido','Sin Corregir','Location','northeast');
end
subplot(2,1,2);
title(['Parte Imaginaria de ' figureName]);
xlabel('Frecuencia (Hz)');
ylabel('Im');


% --- Executes during object creation, after setting all properties.
function Calibrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on button press in config.
function config_Callback(hObject, eventdata, handles)
% hObject    handle to config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('a')


% --- Executes on button press in rb_debugmode.
function rb_debugmode_Callback(hObject, eventdata, handles)
% hObject    handle to rb_debugmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.DebugMode=1;
% Hint: get(hObject,'Value') returns toggle state of rb_debugmode


% --- Executes on button press in cb_debugmode.
function cb_debugmode_Callback(hObject, eventdata, handles)
% hObject    handle to cb_debugmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(handles.cb_debugmode,'Value')==1)
    handles.DebugMode=1;
else
    handles.DebugMode=0;
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of cb_debugmode
