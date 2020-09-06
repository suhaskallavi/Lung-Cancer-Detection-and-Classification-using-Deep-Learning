function varargout = cancer(varargin)
% CANCER M-file for cancer.fig
%      CANCER, by itself, creates a new CANCER or raises the existing
%      singleton*.
%
%      H = CANCER returns the handle to a new CANCER or the handle to
%      the existing singleton*.
%
%      CANCER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANCER.M with the given input arguments.
%
%      CANCER('Property','Value',...) creates a new CANCER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cancer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cancer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cancer



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cancer_OpeningFcn, ...
                   'gui_OutputFcn',  @cancer_OutputFcn, ...
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


% --- Executes just before cancer is made visible.
function cancer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cancer (see VARARGIN)

% Choose default command line output for cancer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cancer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cancer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
clc
[filename, pathname] = uigetfile('*.jpg', 'Pick an Image');
     if isequal(filename,0) | isequal(pathname,0)
      
   warndlg('File is not selected');
           else
              I=imread(filename);
      axes(handles.axes1)
      imshow(I);
      title 'Input Image'     
    end
title 'Input Lung Image'

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
t=rgb2gray(I);
he=histeq(t);

axes(handles.axes2);
imshow(he);
title 'Histogram Equalization'
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
threshold = graythresh(he);
bw = im2bw(he,threshold);

axes(handles.axes3);
imshow(bw)
title 'Segmentation by Thresholding'

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
threshold = graythresh(he);
bw = im2bw(he,threshold);
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
axes(handles.axes4);
imshow(Iy,[]),

title('Filtered Image')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
threshold = graythresh(he);
bw = im2bw(he,threshold);
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);
axes(handles.axes5);
imshow(bw2), 
title('Dilated')

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
%% Segmentation by thresholding
threshold = graythresh(he);
bw = im2bw(he,threshold);

%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);

BW5 = imfill(bw2,'holes');
  axes(handles.axes6);
  imshow(BW5)
 
 title 'Image Filling'
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I
% figure,imshow(I);
% title 'Input Lung Image'
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
% figure,imshow(he);
% title 'Histogram Equalization'
%% Segmentation by thresholding
threshold = graythresh(he);
bw = im2bw(he,threshold);
% figure,imshow(bw)
% title 'Segmentation by Thresholding'
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
se = strel('line',11,90);
bw2 = imdilate(Iy,se);
BW5 = imfill(bw2,'holes');
%% Features Extraction
 %% Contrast
  disp ('Contrast Value');
  cmap = contrast(BW5)

 %% Entropy
 disp ('Entropy Value');
 E = entropy(BW5)
 set(handles.edit2,'string',num2str(E));

 %% GLCM Values
 glcm = graycomatrix(BW5,'Offset',[2 0])

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
% figure,imshow(I);
% title 'Input Lung Image'
%% Histogram Equalization
t=rgb2gray(I);
he=histeq(t);
% figure,imshow(he);
% title 'Histogram Equalization'
%% Segmentation by thresholding
threshold = graythresh(he);
bw = im2bw(he,threshold);
% figure,imshow(bw)
% title 'Segmentation by Thresholding'
%% Filter
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(bw), hy, 'replicate');
% figure, imshow(Iy,[]),
% title('Filtered Image')
se = strel('line',11,90);
bw2 = imdilate(Iy,se);
BW5 = imfill(bw2,'holes');
C=BW5;
%% mean
c1=mean(C);
%% variance
c2=var(double(C));
%% contrast
d=C;

%% energy, homogeneity, contrast
GLCM2 = graycomatrix(d,'Offset',[2 0;0 2]);
c4 = graycoprops(GLCM2,{'contrast','homogeneity','Energy'});
set(handles.edit4,'string',num2str(min(c4.Energy)));
c24= graycoprops(GLCM2,'contrast');
set(handles.edit3,'string',num2str(min(c24.Contrast)));
%% correlation
c5=corr(double(d));
c6=c5(1,:);
c7=c1;
c8=c2;

c9=[c6 c7 c8];
%% network
net = network
net.numInputs = 6
net.numLayers = 1
P = size(double(c1));  
Cidx = strcmp('Cancer',c9); 
T = size(double(c2));         
net = newff(P,T,25);   
[net,tr] = train(net,P,T);
testInputs = P(:,tr.testInd);
testTargets = T(:,tr.testInd);
out = round(sim(net,testInputs));     
diff = [testTargets - 2*out];
detections = length(find(diff==-1))
false_positives = length(find(diff==1))
true_positives = length(find(diff==0))     
false_alarms = length(find(diff==-2))      
Nt = size(testInputs,2);           
fprintf('Total testing samples: %d\n', Nt);
cm = [detections false_positives; false_alarms true_positives] 
cm_p = (cm ./ Nt) .* 100           ;
%%
sim_out = round(sim(net,testInputs)); 
if ((max(c24.Contrast))>2)
    set(handles.edit1,'string','Lung Cancer Affected Image');
else
    set(handles.edit1,'string','Normal Image');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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
