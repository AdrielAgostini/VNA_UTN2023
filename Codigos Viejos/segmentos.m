function varargout = segmentos(varargin)
% segmentos MATLAB code for segmentos.fig   VERSION 3
%      segmentos, by itself, creates a new segmentos or raises the existing
%      singleton*.
%
%      H = segmentos returns the handle to a new segmentos or the handle to
%      the existing singleton*.
%
%      segmentos('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in segmentos.M with the given input arguments.
%
%      segmentos('Property','Value',...) creates a new segmentos or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentos_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentos_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentos

% Last Modified by GUIDE v2.5 06-Nov-2016 13:39:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmentos_OpeningFcn, ...
                   'gui_OutputFcn',  @segmentos_OutputFcn, ...
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


% --- Executes just before segmentos is made visible.
function segmentos_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentos (see VARARGIN)

% Choose default command line output for segmentos
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmentos wait for user response (see UIRESUME)
% uiwait(handles.segmentos);


% --- Outputs from this function are returned to the command line.
function varargout = segmentos_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function initFrec_Callback(hObject, eventdata, handles)
% hObject    handle to initFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initFrec as text
%        str2double(get(hObject,'String')) returns contents of initFrec as a double


% --- Executes during object creation, after setting all properties.
function initFrec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endFrec_Callback(hObject, eventdata, handles)
% hObject    handle to endFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endFrec as text
%        str2double(get(hObject,'String')) returns contents of endFrec as a double


% --- Executes during object creation, after setting all properties.
function endFrec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in initSeg.
function initSeg_Callback(hObject, eventdata, handles)
% hObject    handle to initSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns initSeg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from initSeg


% --- Executes during object creation, after setting all properties.
function initSeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in endSeg.
function endSeg_Callback(hObject, eventdata, handles)
% hObject    handle to endSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns endSeg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from endSeg


% --- Executes during object creation, after setting all properties.
function endSeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pointFrec_Callback(hObject, eventdata, handles)
% hObject    handle to pointFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pointFrec as text
%        str2double(get(hObject,'String')) returns contents of pointFrec as a double


% --- Executes during object creation, after setting all properties.
function pointFrec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addSeg.
function addSeg_Callback(hObject, eventdata, handles)
% hObject    handle to addSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = handles.cant;
%n = n+1;
lugar = 1;
flagSup = 0;

minFreq = str2num(get(handles.initFrec,'String')) * 10^(get(handles.initSeg,'Value') * 3);
maxFreq = str2num(get(handles.endFrec,'String')) * 10^(get(handles.endSeg,'Value') * 3);
sampleNum = str2num(get(handles.pointFrec,'String'));

initFrec_seg = str2num(get(handles.initFrec,'String'));
endFrec_seg = str2num(get(handles.endFrec,'String'));

content = get(handles.initSeg,'string');
initUnit = content{get(handles.initSeg,'Value')};
content = get(handles.endSeg,'string');
endUnit = content{get(handles.endSeg,'Value')};
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(handles.maxFreq_seg(1) == 0)%isempty(handles.maxFreq_seg))
    handles.minFreq_seg(1) = minFreq;
    handles.maxFreq_seg(1) = maxFreq;   
    handles.sampleNum_seg(1) = sampleNum;
    handles.initUnit_seg{1} = initUnit;
    handles.endUnit_seg{1} = endUnit;
    handles.initFrec_seg(1) = initFrec_seg;
    handles.endFrec_seg(1) = endFrec_seg;
    lugar = 1;
else
    if(maxFreq < handles.minFreq_seg(1))
        lugar = 1;
    else
        if(maxFreq == handles.minFreq_seg(1))
            flagSup = 1;
        else
            for i = 1:(n-1)
                if (minFreq > handles.minFreq_seg(i) && minFreq < handles.minFreq_seg(i+1))
                    if(minFreq > handles.maxFreq_seg(i) && maxFreq < handles.minFreq_seg(i+1))
                        lugar = i+1;
                        flagSup = 0;
                        break;
                    else
                        flagSup = 1;
                        break;
                    end
                else
                    if(minFreq == handles.minFreq_seg(i))
                        flagSup = 1;
                        break;
                    else
                        if(maxFreq == handles.maxFreq_seg(i))
                            flagSup = 1;
                            break;
                        else
                            lugar = n;
                            flagSup = 0;
                        end
                    end
                end
            end
        end
    end
    if (flagSup == 0)
        for j = n:-1:lugar %VER
            if (j == 1)
                 break;
            end
            %handles.minFreq_seg(j) = handles.minFreq_seg(n-1);
            handles.minFreq_seg(j) = handles.minFreq_seg(j-1);
            handles.maxFreq_seg(j) = handles.maxFreq_seg(j-1);
            handles.sampleNum_seg(j) = handles.sampleNum_seg(j-1);
            handles.initUnit_seg{j} = handles.initUnit_seg{j-1};
            handles.endUnit_seg{j} = handles.endUnit_seg{j-1};
            handles.initFrec_seg(j) = handles.initFrec_seg(j-1);
            handles.endFrec_seg(j) = handles.endFrec_seg(j-1);
        end
        handles.minFreq_seg(lugar) = minFreq;
        handles.maxFreq_seg(lugar) = maxFreq;
        handles.sampleNum_seg(lugar) = sampleNum;
        handles.initUnit_seg{lugar} = initUnit;
        handles.endUnit_seg{lugar} = endUnit;
        handles.initFrec_seg(lugar) = initFrec_seg;
        handles.endFrec_seg(lugar) = endFrec_seg;
    end
end
if (~flagSup)
    n=n+1;
end
handles.freqVector_seg = [];  %Vacio el vector para generarlo de nuevo
freqVector_seg =[];
lines = [];                   %Vacio la lista para re armarla
line = [];
for i=1:(n-1)
    %handles.minFreq_seg(i)
    freqVector_seg = [freqVector_seg linspace(handles.minFreq_seg(i),handles.maxFreq_seg(i),handles.sampleNum_seg(i))]
    line = strcat('Segmento ', num2str(i), ': ',num2str(handles.initFrec_seg(i)), handles.initUnit_seg(i), '-', num2str(handles.endFrec_seg(i)), handles.endUnit_seg(i), '  puntos: ', num2str(handles.sampleNum_seg(i)));
    %lines = [line; cellstr(line)];
    lines = [lines; cellstr(line)];
end
set(handles.listFrec, 'String', lines);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %freqVector_seg = linspace(minFreq,maxFreq,sampleNum);
% 
% content = get(handles.initSeg,'string');
% initUnit = content{get(handles.initSeg,'Value')};
% content = get(handles.endSeg,'string');
% endUnit = content{get(handles.endSeg,'Value')};
% list = get(handles.listFrec, 'String');
% line = strcat('Segmento ', int2str(n), ': ',get(handles.initFrec,'String'), initUnit, '-', get(handles.endFrec,'String'), endUnit, '  puntos: ', get(handles.pointFrec,'String'));
% %lines = [list, line]
% %lines = {list, line}
% %list(end+1)=line
% lines = [list; cellstr(line)];
% set(handles.listFrec, 'String', lines);
% %set(handles.listFrec,'str',{list{:},line{:}})
% handles.cant = n;
% handles.freqVector_seg = [handles.freqVector_seg , freqVector_seg];
% %handles.freqVector_seg
% 
% % handles.minFreq(n) = minFreq
% % handles.maxFreq(n) = maxFreq
% % handles.sampleNum(n) = sampleNum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.cant = n;
handles.freqVector_seg = freqVector_seg;
guidata(hObject, handles);

% --- Executes on selection change in listFrec.
function listFrec_Callback(hObject, eventdata, handles)
% hObject    handle to listFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listFrec contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listFrec


% --- Executes during object creation, after setting all properties.
function listFrec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listFrec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%set(handles.listFrec, 'String', handles.lines);

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', handles.lines);



% --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% h = findobj('Tag','vnagui');
% fig1Data = guidata(h);
% set(fig1Data.vnagui, 'Visible', 'on');
% set(handles.segmentos, 'Visible', 'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setappdata (vnaGUI, 'freqseg', handles.freqVector_seg);
setappdata (vnaGUI, 'lines', get(handles.listFrec, 'String'));
setappdata (vnaGUI, 'cant', handles.cant);
close(segmentos);




% --- Executes during object creation, after setting all properties.
function segmentos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segmentos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.main_handle = getappdata(0,'main_handle'); 
handles.freqVector_seg = 0;
handles.cant = 1;
%%%%%%%%%%%%%%%%%%%%
handles.freqVector_seg = getappdata(0,'freqseg');
handles.lines = getappdata(0,'lines');
handles.cant = getappdata(0,'cant');
%%%%%%%%%%%%%%%%%%%%%
handles.minFreq_seg = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];%double.empty(10,0);%[];%
handles.maxFreq_seg = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];%double.empty(10,0);%[];
handles.sampleNum_seg = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];%double.empty(10,0);%[];
handles.initUnit_seg = [];%int16.empty(10,0);%[];
handles.endUnit_seg = [];%int16.empty(10,0);%[];
handles.initFrec_seg = [];
handles.endFrec_seg = [];
%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles);


% --- Executes on button press in delSeg.
function delSeg_Callback(hObject, eventdata, handles)
% hObject    handle to delSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lines = [];
set(handles.listFrec, 'String', lines);
%handles.freqVector_seg = [];
handles.cant = 1;
%%%%%%%%%%%%%%%%%%%%%
handles.minFreq_seg = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];%double.empty(10,0);%[];%
handles.maxFreq_seg = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];%double.empty(10,0);%[];
handles.sampleNum_seg = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];%double.empty(10,0);%[];
handles.initUnit_seg = [];%int16.empty(10,0);%[];
handles.endUnit_seg = [];%int16.empty(10,0);%[];
handles.initFrec_seg = [];
handles.endFrec_seg = [];
%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function segmentos_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to segmentos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
