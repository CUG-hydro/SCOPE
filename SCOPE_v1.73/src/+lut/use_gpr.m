function use_gpr(gpr_path, full_set_path)

    if nargin == 0
        in_dir = '../exercise';
        gpr_path = fullfile(in_dir, 'gpr.mat');
        full_set_path = fullfile(in_dir, 'full_set.csv');
    end
    csv_out = fullfile(fileparts(full_set_path), 'results_gpr.csv');
    map_out = fullfile(fileparts(full_set_path), 'results_gpr.tif');
    fig_out = fullfile(fileparts(full_set_path), 'results_gpr.png');

    gpr = load(gpr_path);
    gprMdl = gpr.gprMdl;
    val_in = readtable(full_set_path);
    
    fprintf('Working, usually takes around 1 minute\n')
    res = predict(gprMdl, val_in);
    
    tab = array2table(res, 'VariableNames', {'Actot'});
    writetable(tab, csv_out)
    fprintf('saved `%s`', csv_out)
    
    im = lut.csv2image_plane(val_in, res);
    imwrite(im, map_out)
    
    figure
    imagesc(im)
    cb = colorbar;
    title(cb, '[\mumol CO_2 cm^{-2} s^{-1}]')
    title('GPR GPP')
    saveas(gcf, fig_out)
end