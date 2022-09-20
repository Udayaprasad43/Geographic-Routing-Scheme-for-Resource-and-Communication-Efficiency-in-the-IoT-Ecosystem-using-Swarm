function varargout = GUI_CODE(varargin)
% GUI_CODE MATLAB code for GUI_CODE.fig
%      GUI_CODE, by itself, creates a new GUI_CODE or raises the existing
%      singleton*.
%
%      H = GUI_CODE returns the handle to a new GUI_CODE or the handle to
%      the existing singleton*.
%
%      GUI_CODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CODE.M with the given input arguments.
%
%      GUI_CODE('Property','Value',...) creates a new GUI_CODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_CODE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_CODE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_CODE

% Last Modified by GUIDE v2.5 07-Aug-2019 15:56:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_CODE_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_CODE_OutputFcn, ...
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


% --- Executes just before GUI_CODE is made visible.
function GUI_CODE_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_CODE (see VARARGIN)

[handles.nodex_g,handles.nodey_g,handles.nodex_e,handles.nodey_e,handles.nodex,handles.nodey]=deploy_nodes;

% set(handles.pushbutton1,'Enable','off') 
set(handles.pushbutton2,'Enable','off') 
set(handles.pushbutton3,'Enable','off') 

% Choose default command line output for GUI_CODE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_CODE wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_CODE_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(~, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
clc
cla

axes(handles.axes2)
clc
cla

load coeff

handles.edit1 = str2num((get(handles.edit1,'String')));
handles.edit2 = str2num((get(handles.edit2,'String')));

handles.edit3 = str2num((get(handles.edit3,'String')));
handles.edit4 = str2num((get(handles.edit4,'String')));
handles.edit5 = str2num((get(handles.edit5,'String')));
handles.edit6 = str2num((get(handles.edit6,'String')));
handles.edit7 = str2num((get(handles.edit7,'String')));
handles.edit8 = str2num((get(handles.edit8,'String')));

P_rx=rand;
P_tx=rand;
P_idle=rand;
P_startup=rand/2;

nodex_g=handles.nodex_g;
nodey_g=handles.nodey_g;
nodex_e=handles.nodex_e;
nodey_e=handles.nodey_e;
nodex=handles.nodex;
nodey=handles.nodey;

s=handles.edit1;
r=handles.edit2 ;

P_tx=handles.edit3;
P_rx=handles.edit4;
P_idle=handles.edit5;
P_startup=handles.edit6;

[~,~,~,~,~,~,~,~,~,~,~,~,beta,delta,gamma,P_sleep]=markovmodel(P_tx,P_rx,P_idle,P_startup);

% ---------------------------------------------------------------------------
% HOP BY HOP RETRANSMISSION STRATEGY
% ---------------------------------------------------------------------------
axes(handles.axes1)

hold on
for i=1:size(nodex,2)
    plot(nodex(i),nodey(i),'b*')
    text(nodex(i)+0.05,nodey(i),[num2str(i)])
end

title('HOP BY HOP RETRANSMISSION STRATEGY')

[ROUTE_NODES,~,faultcount,tym,~]=sender_to_receiver1(nodex_g,nodey_g,nodex_e,nodey_e,nodex,nodey,s,r);  % this function sends the information from sender to receiver
axis equal

pdr=(size(ROUTE_NODES,1)-faultcount)/(size(ROUTE_NODES,1));
avgdelay=sum(tym)/length(tym);
total_size=100;
throughput=total_size/sum(tym);
detection_ratio=faultcount/(size(ROUTE_NODES,1));

pdr=(size(ROUTE_NODES,1)-faultcount)/(size(ROUTE_NODES,1));
avgdelay=sum(tym)/length(tym);
total_size=100;
throughput=total_size/sum(tym);
detection_ratio=faultcount/(size(ROUTE_NODES,1));
disp('---------------------------------------------------------------------')
disp('Results for routing 1')
disp('---------------------------------------------------------------------')
disp(['Packet delivery ratio: ' num2str(pdr)])
disp(['Average end to end delay: ' num2str(avgdelay)])
disp(['Network throughput: ' num2str(throughput)])
disp(['Fault detection ratio: ' num2str(detection_ratio)])
hold off

pdr_final(1)=pdr;
avgdelay_final(1)=avgdelay;
throughput_final(1)=throughput;
detection_ratio_final(1)=detection_ratio;


% ---------------------------------------------------------------------------
% END TO END RETRANSMISSION STRATEGY
% ---------------------------------------------------------------------------
axes(handles.axes2)
hold on
for i=1:size(nodex,2)
    plot(nodex(i),nodey(i),'b*')
    text(nodex(i)+0.05,nodey(i),[num2str(i)])
end

title('END TO END RETRANSMISSION STRATEGY')

[ROUTE_NODES,DE_NODES,faultcount,tym,FIT]=sender_to_receiver2(nodex_g,nodey_g,nodex_e,nodey_e,nodex,nodey,s,r);  % this function sends the information from sender to receiver
axis equal

pdr=(size(ROUTE_NODES,1)-faultcount)/(size(ROUTE_NODES,1));
avgdelay=sum(tym)/length(tym);
total_size=100;
throughput=total_size/sum(tym);
detection_ratio=faultcount/(size(ROUTE_NODES,1));

pdr=(size(ROUTE_NODES,1)-faultcount)/(size(ROUTE_NODES,1));
avgdelay=sum(tym)/length(tym);
total_size=100;
throughput=total_size/sum(tym);
detection_ratio=faultcount/(size(ROUTE_NODES,1));
disp('---------------------------------------------------------------------')
disp('Results for routing 2')
disp('---------------------------------------------------------------------')
disp(['Packet delivery ratio: ' num2str(pdr)])
disp(['Average end to end delay: ' num2str(avgdelay)])
disp(['Network throughput: ' num2str(throughput)])
disp(['Fault detection ratio: ' num2str(detection_ratio)])
hold off

pdr_final(2)=pdr;
avgdelay_final(2)=avgdelay;
throughput_final(2)=throughput;
detection_ratio_final(2)=detection_ratio;


handles.P_sleep = P_sleep;
handles.gamma = gamma;
handles.delta = delta;
handles.beta = beta;
handles.pdr_final = pdr_final;
handles.avgdelay_final = avgdelay_final;
handles.throughput_final = throughput_final;
handles.detection_ratio_final = detection_ratio_final;


set(handles.pushbutton2,'Enable','on') 

guidata(hObject, handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

res(handles);


guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)
clc
cla
x=[0 20 40];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {' ',' ',' '};
pause(0.5)
y=[0 20 40];
ay = gca;
set(gca,'XTick',y)
ay.YAxis.TickLabel = {' ',' ',' '};
% pause(0.5)

axes(handles.axes2)
clc
cla
x=[0 20 40];
ax = gca;
set(gca,'XTick',x)
ax.XAxis.TickLabel = {' ',' ',' '};
pause(0.5)
y=[0 20 40];
ay = gca;
set(gca,'XTick',y)
ay.YAxis.TickLabel = {' ',' ',' '};
% pause(0.5)

bfoa(handles);

set(handles.pushbutton3,'Enable','on') 

guidata(hObject, handles);
