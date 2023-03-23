function [] = extract_song_audio(song_dir, output_dir, filename)
    %%%%%%%%%%%%%%% the rest should be fine as it is %%%%%%%%%%%%%%%%%%%%
    disp(song_dir)
    cd(song_dir)
    file_name = dir('*.mp3');
    for ii = 1:length(file_name)
    song_name{ii} = file_name(ii).name;
    end
    song_title = cell2table(song_name','VariableNames',{'song_title'});
    data_table = nan(length(file_name), 24);
    feature_name = {'spectral_centroid','spectral_spread',...
        'spectral_flux','roughness','attack_time','entropy','RMS_energy',...
        'flatness','subband1','subband2','subband3','subband4','subband5',...
        'subband6','subband7','subband8','subband9','subband10','key_clarity',...
        'pulse_clarity','mode','fluctuation_centroid','fluctuation_entropy', 'novelty'};

    %% setting up frames and sampling rates for every audio clip for short term 
    %features
    a = miraudio('Folder', 'Frame', 0.025);

    %% spectral centroid measure
    %used 'mirstat' here to get the average across frames b/c it filters for
    %NAs, and 'mirmean' does not
    b = mircentroid(a);
    spectral_centroid_stats = mirstat(b);
    spectral_centroid = spectral_centroid_stats.Mean;
    data_table(:,1) = spectral_centroid;

    %% spectral spread measure
    c = mirspread(a);
    spectral_spread_stats = mirstat(c);
    spectral_spread = spectral_spread_stats.Mean;
    data_table(:,2) = spectral_spread;

    %% spectral flux measure
    d = mirflux(a);
    ca = mirmean(d);
    spectral_flux = mirgetdata(ca);
    data_table(:,3) = spectral_flux;

    %% roughness measure
    e = mirroughness(a);
    ef = mirmean(e);
    roughness = mirgetdata(ef);
    data_table(:,4) = roughness;

    %% mirattacktime
    %was having trouble getting some of these songs' attack time, but it worked
    %when i increased the frame rate
    fp = mirevents('Folder', 'Frame', 1);
    f = mirattacktime(fp);
    fpf = mirmean(f);
    attack_time = mirgetdata(fpf);
    data_table(:,5) = attack_time;

    %% mirentropy measure
    g = mirentropy(a);
    gf = mirmean(g);
    entropy = mirgetdata(gf);
    data_table(:,6) = entropy;

    %% RMS energy measure
    h = mirrms(a);
    hf = mirmean(h);
    RMS_energy = mirgetdata(hf);
    data_table(:,7) = RMS_energy;

    %% flatness measure
    i = mirflatness(a);
    fi  = mirmean(i);
    flatness = mirgetdata(fi);
    data_table(:,8) = flatness;

    %% sub-band fluxes
    %since the final version of this output is a matrix, this might present
    %problems combining with other variables, so im okay if this has to be its
    %own outpu/.csv
    j = mirflux('Folder', 'SubBand', 'Frame', 0.025);
    sub_band_fluxes_stats = mirstat(j);
    sub_band_fluxes_allmeans = sub_band_fluxes_stats.Mean;
    sub_band_fluxes_means = squeeze(sub_band_fluxes_allmeans);
    data_table(:,9:18) = sub_band_fluxes_means;

    %% setting up files for long-term feature extraction (frames = 3s)
    l = miraudio('Folder', 'Frame', 3);

    %% key clarity 
    m = mirchromagram(l);
    [n, ns] = mirkey(m, "Total", 1);
    sns = mirmean(ns);
    key_clarity = mirgetdata(sns);
    data_table(:,19) = key_clarity;

    %% pulse clarity
    lp = mirevents('Folder', 'Frame', 1);
    lpl = mirpulseclarity(lp);
    lplp = mirmean(lpl);
    pulse_clarity = mirgetdata(lplp);
    data_table(:,20) = pulse_clarity;

    %% mode
    %used 'l' here because mode in Salakka paper was calculated using a
    %chromagram
    q = mirmode(l, 'Best');
    qp = mirmean(q);
    mode = mirgetdata(qp);
    data_table(:,21) = mode;


    %% fluctuation centroid
    fc = mirfeatures(l);
    fluctuation_centroid = fc.fluctuation.centroid;
    fluctuation_centroid = mirstat(fluctuation_centroid);
    fluctuation_centroid = fluctuation_centroid.Mean;
    data_table(:,22) = fluctuation_centroid;

    %% fluctuation entropy
    t = mirfluctuation(l, 'Summary');
    te = mirentropy(t);
    fluctuation_entropy = mirgetdata(te);
    data_table(:,23) = fluctuation_entropy;

    %% novelty
    z = mirsimatrix(l);
    o = mirnovelty(z);
    op = mirmean(o);
    novelty = mirgetdata(op);
    data_table(:,24) = novelty;

    %% create dataframe
    cd ..
    data_MIR = array2table(data_table,'VariableNames',feature_name);
    data = [song_title,data_MIR];
    writetable(data,fullfile(output_dir, filename));
end