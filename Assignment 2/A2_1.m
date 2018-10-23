%clc; clear all; close all;

%video = VideoReader('./data/face.mp4'); % 528*592
video = VideoReader('./data/baby2.mp4'); % 640*352

height = video.Height;
width = video.Width;
frame_rate = video.FrameRate; % 30 frame/sec
frame_number = video.NumberOfFrames;
video_ = read(video);

video_rgb = zeros(height, width, 3, frame_number);
video_rgb(:, :, :, :) = im2double(video_(:, :, :, 1:frame_number));
video_yiq = zeros(height, width, 3, frame_number);
for frame = 1:frame_number
    video_yiq(:, :, :, frame) = rgb2ntsc(video_rgb(:, :, :, frame));
end

clear video;
clear video_frame_double;