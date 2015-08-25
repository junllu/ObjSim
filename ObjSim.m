%2-D Object on 2-D Surface Distribution Simulation
%Created by: Jun Lu
%Professor Kante

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This Simulation will be done in Black and White Scale for simplicity,
%it ca be further development to incorporate other colors

%2-D Surface Initiatlization - Assuming the size of the 2-D surface is defined.
surf = zeros(5000,5000);
new_surf = zeros(5000,5000);
[surf_wid surf_height] = size(surf);

%Declaring object
%obj = imread("xxx.tif") %object through reading in the image.
obj = zeros(300,500);
obj(5:200, 100:400) = 1 ;  %rectangle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Defining Terminating Parameter%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
term_coverage  = 0.65;
term_count = 50;
figure(1)
surf_coverage = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Distributing the Object on the Surface 
count = 1;
check_count = 0;
tic;
particle_index = zeros(100,3);
used_indices = zeros(100,2);

while surf_coverage < term_coverage 
    %Initializing the Object
            %Rotating Object @ a random degrees
            rand_degrees = randi([0,179]);
            rotated_obj = imrotate(obj, rand_degrees);
            %imshow(rotated_obj);

            %Analyzing the Object
            [r c] = find(rotated_obj == 1);
            height = (max(r) - min(r))+2;
            width = (max(c) - min(c))+2;

            new_object = rotated_obj(min(r)-1:max(r)+1, min(c)-1:max(c)+1);
            %figure
            %imshow(new_object)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%Placing the object on the surface%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            randi_count= 0;                 %Counting random positions generated in total

            %Determining Position 
            while open_len < ((height - 3)*(width -3))
                initial_row = randi([1,4999-height]);		%Initial Row and Column 
                initial_col = randi([1,4999-width]);

                current_location = [initial_row initial_col];

            %Checking the repeated Indices
                used_indicies = particle_index(: , 1:2);         
                check = ismember(current_location,used_indicies,'rows');

               if check == 1
                   break;
               end
            %Move on if Initial rows and columns are not already used
                end_row = initial_row + height;				%End Row and Column
                end_col = initial_col + width;	
                
                %Checking Bottom Corner (Add Three other Corner)
                surf_seg = new_surf(initial_row:end_row, initial_col:end_col);		%extracting placement section
                        %figure
                        %imshow(surf_seg)
                [open_r open_c] = find(surf_seg == 0);	
                open_len = length(open_r);	%counting open spaces

                %Verify if the Space is Open
                    randi_count = randi_count + 1;
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            %Indexing information for each particle
            particle_index(count,:,:) = [initial_row initial_col rand_degrees];


            %Placing the particle onto the surface
            new_surf(initial_row:end_row, initial_col:end_col) = new_object + surf_seg;
                        %figure
                        imshow(new_surf);


    black = find(new_surf == 0);
    white = find(new_surf == 1);

    surf_coverage = length(white)/length(black);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Terminating Parameter %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % if surf_coverage <= term_coverage
    %       continue;
    % else
    %       break;
    % end
        
%     if count <  term_count
%             count = count + 1;
%             continue
%     else
%             break;
%     end
    
    end
    
  toc;
  imshow(new_surf);
  surf_coverage 

     

%Post Distribution Surface Analysis

%Forier Transform of the Image
F1 = abs(fft2(double(new_surf)));
figure(2)
imshow(F1,[]), title('Forier Transform of the Original Image')

%Centered Fourier Transform of the Image
F2 = fftshift(F1);
figure(3)
imshow(F2,[]), title('Centered Fourier Transform of Image')


%Log Transform to improve resolution
max_F = max(max(F1))
min_F = min(min(F1))
F3 = log(1+abs(F2));
figure(4)
imshow(F3,[]), title('Log Transformed Image')

%Recontructed image
F4 = ifft2(ifftshift(F1));
figure(5)
imshow(F4,[]), title('Recontructed Image')
