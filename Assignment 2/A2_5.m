LP_{1} = filtered_LP{1};
LP_{2} = Doubling(filtered_LP{2}, filtered_LP{1});
LP_{3} = Doubling(Doubling(filtered_LP{3}, filtered_LP{2}), filtered_LP{1});
LP_{4} = Doubling(Doubling(Doubling(filtered_LP{4}, filtered_LP{3}), filtered_LP{2}), filtered_LP{1});
LP_{5} = Doubling(Doubling(Doubling(Doubling(filtered_LP{5}, filtered_LP{4}), filtered_LP{3}), filtered_LP{2}), filtered_LP{1});
%LP_{6} = Doubling(Doubling(Doubling(Doubling(Doubling(filtered_LP{6}, filtered_LP{5}), filtered_LP{4}), filtered_LP{3}), filtered_LP{2}), filtered_LP{1});
amplified_LP = LP_{1}+LP_{2}+LP_{3}+LP_{4}*120+LP_{5}*120;
    %+LP_{6}*120
video_result = abs(video_yiq(:, :, :, :) + amplified_LP(:, :, :, :));

video_final = zeros(height, width, 3, frame_number);
for i = 1:frame_number
    video_final(:, :, :, i) = ntsc2rgb(video_result(:, :, :, i));
end

%vidout = VideoWriter('face', 'MPEG-4');
vidout = VideoWriter('baby2', 'MPEG-4');
open(vidout)
for i = 1:frame_number
    writeVideo(vidout, video_final(:, :, :, i))
end
close(vidout)

% ====================================================================================================
clear filtered_LP;
clear resized_filtered_LP;
clear video_yiq_LP;
