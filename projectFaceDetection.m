function varargout = projectFaceDetection(varargin)
% PROJECTFACEDETECTION MATLAB code for projectFaceDetection.fig
%      PROJECTFACEDETECTION, by itself, creates a new PROJECTFACEDETECTION or raises the existing
%      singleton*.
%
%      H = PROJECTFACEDETECTION returns the handle to a new PROJECTFACEDETECTION or the handle to
%      the existing singleton*.
%
%      PROJECTFACEDETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECTFACEDETECTION.M with the given input arguments.
%
%      PROJECTFACEDETECTION('Property','Value',...) creates a new PROJECTFACEDETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projectFaceDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projectFaceDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projectFaceDetection

% Last Modified by GUIDE v2.5 24-Dec-2022 18:37:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projectFaceDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @projectFaceDetection_OutputFcn, ...
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


% --- Executes just before projectFaceDetection is made visible.
function projectFaceDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projectFaceDetection (see VARARGIN)

% Choose default command line output for projectFaceDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projectFaceDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projectFaceDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Upload_Picture.
function Upload_Picture_Callback(hObject, eventdata, handles)
% hObject    handle to Upload_Picture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
   
        
       filename=strcat(pathname,filename);
       a=imread(filename);
       axes(handles.axes1);
       imshow(a);
       handles.a = a;
       guidata(hObject, handles);


% --- Executes on button press in Add_Noise.
function Add_Noise_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

J=handles.a;
noise_level=input('How much noise you want to add?(eg input 0.1 for 10%:');
noisy_image=imnoise(J,'salt & pepper',noise_level);
axes(handles.axes3);
imshow(noisy_image);
title('Noisy Image');



% --- Executes on button press in Median_Filter.
function Median_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Median_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I=handles.a;
med=medfilt3(I,[3,5,3])
axes(handles.axes3)
imshow(med)
title('Filtered Image');



% --- Executes on button press in Enhance_Image.
function Enhance_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Enhance_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 I =handles.a;

se=strel('disk',150)
Background=imopen(I,se)
enhance=I-Background;
axes(handles.axes3)
  imshow(enhance)
title('Enhanced Image');

% --- Executes on button press in Binary_Image.
function Binary_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Binary_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.a;
binary=im2bw(image);
axes(handles.axes3)
imshow(binary)
title('Binary Image');
% --- Executes on button press in Gray_Image.
function Gray_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Gray_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.a;
gray=rgb2gray(image);
axes(handles.axes3)
imshow(gray)

title('Gray Image');
% --- Executes on button press in Detect_Eye.
function Detect_Eye_Callback(hObject, eventdata, handles)
% hObject    handle to Detect_Eye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Detector=vision.CascadeObjectDetector('EyePairSmall');
% Detector.MinSize=[15 25];
% Detector.MergeThreshold=16;
image=handles.a;
boundingbox=step(Detector,image);
detpic=insertObjectAnnotation(image,'rectangle',boundingbox,'Eyes');
axes(handles.axes3)
imshow(detpic)
title('Eye Detection');


% --- Executes on button press in Detect_Face.
function Detect_Face_Callback(hObject, eventdata, handles)
% hObject    handle to Detect_Face (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.a;
face_Detector=vision.CascadeObjectDetector();%%get face detector object
location=step(face_Detector,image);%%Use face detector on image to get faces
detected_face=insertObjectAnnotation(image,'Rectangle',location,'Face');%%annotate the faces on top of image
axes(handles.axes3)
imshow(detected_face),title('detected faces');
n=size(location,1);
string=num2str(n);
str=strcat('number of faces on photograph=',string);
disp(str);%%display number of faces in a string
title('Face Detection');

% --- Executes on button press in WebCam.
function WebCam_Callback(hObject, eventdata, handles)
% hObject    handle to WebCam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all
clear('web');
viewimage=webcam();
facedet=snapshot(viewimage);
imdet=vision.CascadeObjectDetector();
imshow(facedet);

while true
    facedet=snapshot(viewimage);%%to get image from video
    facedet2=rgb2gray(facedet);
    boundingbox=step(imdet,facedet2);
    pic=insertObjectAnnotation(facedet,'rectangle',boundingbox,'Face');
    imshow(pic);
end

 
% --- Executes on button press in Detect_Nose.
function Detect_Nose_Callback(hObject, eventdata, handles)
% hObject    handle to Detect_Nose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Detector=vision.CascadeObjectDetector('Nose');
Detector.MinSize=[15 25];
Detector.MergeThreshold=16;
image=handles.a;
boundingbox=step(Detector,image);
detpic=insertObjectAnnotation(image,'rectangle',boundingbox,'Nose');
axes(handles.axes3)
imshow(detpic)
title('Nose Detection');

% --- Executes on button press in Detect_Mouth.
function Detect_Mouth_Callback(hObject, eventdata, handles)
% hObject    handle to Detect_Mouth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Detector=vision.CascadeObjectDetector('Mouth');
Detector.MinSize=[15 25];
Detector.MergeThreshold=120;
image=handles.a;
boundingbox=step(Detector,image);
detpic=insertObjectAnnotation(image,'rectangle',boundingbox,'Mouth');
axes(handles.axes3)
imshow(detpic)
title('Mouth Detection');

% --- Executes on button press in Clear_Image.
function Clear_Image_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset');
cla(handles.axes3,'reset');

% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);





% --- Executes on selection change in EdgeDetection.
function EdgeDetection_Callback(hObject, eventdata, handles)
% hObject    handle to EdgeDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EdgeDetection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EdgeDetection
I=handles.a;
img=rgb2gray(I);
k=get(handles.EdgeDetection,'value');
switch k
    case 2
        e=edge(img,'Sobel');
    case 3
        e=edge(img,'Prewitt');
    case 4
        e=edge(img,'Canny');
    case 5
        e=edge(img,'LOG');
    case 6
        e=edge(img,'Roberts');

end
axes(handles.axes3);
if isequal(k,1)
    imshow(I)
else
    imshow(e);
     title('Edge Detection');
end    
% --- Executes during object creation, after setting all properties.
function EdgeDetection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EdgeDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.



% --- Executes during object creation, after setting all properties.

% --- Executes during object creation, after setting all properties.
