clear; clc; close all;
demo_mode = false;
%% Initiate input data
%Load Hyperspectral Image
hyperspectral_input = hypercube('Data/f060925t01p00r17rdn_c_sc01_ort_img$x_308_y_3196$wetland.hdr');
wavelength_img = hyperspectral_input.Wavelength;
hs_img = hyperspectral_input.DataCube;
fieldnames(hyperspectral_input);

% Load curves file
color_curves_input = 'SensCurves_WRGBCMY.txt';
data = readmatrix(color_curves_input);

% Extract each color
wavelength = data(:,1);
R = data(:,2);
G = data(:,3);
B = data(:,4);
C = data(:,5);
M = data(:,6);
Y = data(:,7);

% Get input and target dimensions
[x_size, y_size, band_size] = size(hs_img);
target_size = size(wavelength,1);
step = (max(wavelength) - min(wavelength)) / target_size;  % Define by λmax - λmin / nbr_sample

%% Iteration of each pixel
if not(demo_mode)
    % Prepare output CSV file
    header = {'x', 'y', 'R', 'G', 'B', 'C', 'M', 'Y'};
    responses = [];

    for x = 1:x_size
        for y = 1:y_size
            % Graph extraction for this pixel
            full_spectrum_pixel = squeeze(hs_img(x, y, :));
            cropped_spectrum_pixel = crop_spectrum(hs_img, wavelength_img, wavelength, x, y);
            idx = find(wavelength_img >= min(wavelength) & wavelength_img <= max(wavelength));
            wavelength_cropped = wavelength_img(idx);
            [interpolated_spectrum_pixel, new_wavelength] = interpolate_spectrum(cropped_spectrum_pixel, wavelength_cropped, target_size);
    
            % Calculate colored responses for each color curve
            R_response = get_colored_response(get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, 'R', wavelength, R, G, B, C, M, Y), step);
            G_response = get_colored_response(get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, 'G', wavelength, R, G, B, C, M, Y), step);
            B_response = get_colored_response(get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, 'B', wavelength, R, G, B, C, M, Y), step);
            C_response = get_colored_response(get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, 'C', wavelength, R, G, B, C, M, Y), step);
            M_response = get_colored_response(get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, 'M', wavelength, R, G, B, C, M, Y), step);
            Y_response = get_colored_response(get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, 'Y', wavelength, R, G, B, C, M, Y), step);
            responses = [responses; R_response, G_response,  B_response, C_response, M_response, Y_response];
            disp(['Have done pixel: ' num2str(x) ' x ' num2str(y) ])
        end
    end

    % Normalize by setting global maximal intensity value of the image by color
    normalized_responses = responses;
    for col = 1:size(responses, 2)
        max_val = max(responses(:, col));
        if max_val ~= 0
            normalized_responses(:, col) = responses(:, col) / max_val;
        end
    end

    [x_coords, y_coords] = meshgrid(1:x_size, 1:y_size);
    x_coords = x_coords(:);
    y_coords = y_coords(:);
    
    full_table = [x_coords, y_coords, normalized_responses];
    writecell([header; num2cell(full_table)], 'output/colored_response_XYRGBCMYe_wetland_color_volume_based.csv');
end


%% Functions Definition
function cropped_spectrum = crop_spectrum(hs_img, hs_wavelength, target_wavelength, x, y)
    full_spectrum = squeeze(hs_img(x, y, :));
    idx = find(hs_wavelength >= min(target_wavelength) & hs_wavelength <= max(target_wavelength));
    cropped_spectrum = full_spectrum(idx);
end

function [interpolated_spectrum, new_wavelength] = interpolate_spectrum(cropped_spectrum, wavelength_cropped, target_size)
    wavelength_cropped = double(wavelength_cropped);
    cropped_spectrum = double(cropped_spectrum);
    min_wl = 300; 
    max_wl =  max(wavelength_cropped); 

    % If no value at 300nm (always true) then add a point at 300nm with 0 intensity
    if wavelength_cropped(1) > min_wl
        wavelength_cropped = [min_wl; wavelength_cropped];
        cropped_spectrum = [0; cropped_spectrum];
    end

    new_wavelength = linspace(min_wl, max_wl, target_size);
    interpolated_spectrum = interp1(wavelength_cropped, cropped_spectrum, new_wavelength, 'spline');
    interpolated_spectrum = max(interpolated_spectrum, 0); % Avoid negative values 
end

function colored_spectrum = get_colored_spectrum(interpolated_spectrum, new_wavelength, color_curve, wavelength, R, G, B, C, M, Y)
    % Define which color reponse will be computed
    switch color_curve
        case 'R'
            color_values = R;
        case 'G'
            color_values = G;
        case 'B'
            color_values = B;
        case 'C'
            color_values = C;
        case 'M'
            color_values = M;
        case 'Y'
            color_values = Y;
        otherwise
            error('Invalid color input. Use R, G, B, C, M or Y.');
    end

    color_values_interpolated = interp1(wavelength, color_values, new_wavelength, 'spline', 'extrap');
    colored_spectrum = interpolated_spectrum .* color_values_interpolated;
end

function colored_response = get_colored_response(colored_spectrum, step)
    integrated_response = trapz(colored_spectrum);
    colored_response = (integrated_response * step) / 16384;
end


%% Visal Présentation of full treatment for one pixel
if demo_mode
    x = 150;
    y = 200;
    color_curve = 'B';
    step = 0.2; % Define by λmax - λmin / nbr_sample --NA-> (900-300)/3000

    % Graph extraction
    full_spectrum_pixel = squeeze(hs_img(x, y, :));
    cropped_spectrum_pixel = crop_spectrum(hs_img, wavelength_img, wavelength, x, y);
    idx = find(wavelength_img >= min(wavelength) & wavelength_img <= max(wavelength));
    wavelength_cropped = wavelength_img(idx);
    [interpolated_spectrum_pixel, new_wavelength] = interpolate_spectrum(cropped_spectrum_pixel, wavelength_cropped, target_size);

    colored_spectrum = get_colored_spectrum(interpolated_spectrum_pixel, new_wavelength, color_curve, wavelength, R, G, B, C, M, Y);
    colored_response = get_colored_response(colored_spectrum, step);

    % Plot
    figure;
    plot(wavelength_img, full_spectrum_pixel, 'b-', 'LineWidth', 1.2);
    xlabel('Wavelength (nm)');
    ylabel('Intensity');
    title(['Full Spectrum for pixel (x=' num2str(x) ', y=' num2str(y) ')']);
    grid on;

    figure;
    plot(wavelength_cropped, cropped_spectrum_pixel, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor','r');
    xlabel('Wavelength (nm)');
    ylabel('Intensity');
    title(['Cropped Spectrum for pixel (x=' num2str(x) ', y=' num2str(y) ')']);
    grid on;

    figure;
    plot(new_wavelength, interpolated_spectrum_pixel, 'gx-', 'LineWidth', 1.5, 'MarkerFaceColor','g');
    xlabel('Wavelength (nm)');
    ylabel('Intensity');
    title(['Cropped Interpolated Spectrum for pixel (x=' num2str(x) ', y=' num2str(y) ')']);
    grid on;

    figure;
    plot(new_wavelength, colored_spectrum, 'b-', 'LineWidth', 1.5);
    xlabel('Wavelength (nm)');
    ylabel('Intensity');
    title(['Colored Spectrum for Pixel (x = ' num2str(x) ', y = ' num2str(y) ') with Blue curve']);
    grid on;

    disp(['The Color response for Blue is ' num2str(colored_response)])

end