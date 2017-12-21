%OI = imread('DataSet\CT-MONO2-8-abdo.dcm.bmp');
w = 'trideptraivodoi';
try     % co loi trong try thi lam` catch neu ko loi thi ra ngoai
    getQR();
catch 
    w = encode_qr(w, 'Character_set', 'ISO-8859-1');
end
watermark = w;      % watermark
Denta = 1;          % T
m = 1;              % d/m

TapCover =  dir('DataSet\*.bmp');
for i = 1:length(TapCover)
    cover = strcat('DataSet\',TapCover(i).name)
    OI = imread(cover);
    
    % Embedded %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    LS = liftwave('cdf2.2','Int2Int');
    [CA,CH,CV,CD] = lwt2(double(OI),LS);
    [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD);
    [CD_Modi size_W KEY Check] = embedding_Shitf0_dchiam_IWT_(Denta, m, CD,watermark,c_Cross,r_Cross,uh_Cross,u_Cross);
    watermarkedImage = ilwt2(CA,CH,CV,CD_Modi,LS);
    watermarkedImage_Uint8 = uint8(watermarkedImage);
    watermarkedImage_Error = watermarkedImage - double(watermarkedImage_Uint8);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid = fopen(strcat('DataSet_IWT',TapCover(i).name,'.txt'),'w');
    
    %average filtering
    h = fspecial('average', [5, 5]);
    meanImageAttacked = filter2(h, watermarkedImage_Uint8);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(meanImageAttacked) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n average filtering ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
        fprintf(fid,'Rut duoc-%s ',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OImage,OI));

    %motion blur
    LEN = 21;
    THETA = 11;
    PSF = fspecial('motion', LEN, THETA);
    blurred = imfilter(watermarkedImage_Uint8, PSF, 'conv', 'circular');
    %[watermark_1_extracted] = watermark_extraction_1(blurred, RoiMap, Uw1, Vw1, key1);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(blurred) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n motion blur ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OI,OImage));

    %hisogram equa
    histogram = histeq(watermarkedImage_Uint8);
    %[watermark_1_extracted] = watermark_extraction_1(histogram, RoiMap, Uw1, Vw1, key1);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(histogram) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n hisogram equa ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OI,OImage));

    %median fileter
    medianfilter = medfilt2(watermarkedImage_Uint8,[15 15]);
    %[watermark_1_extracted] = watermark_extraction_1(medianfilter, RoiMap, Uw1, Vw1, key1);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(medianfilter) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n median fileter');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f ',PSNR(OI,OImage));

    %Sharpen
    temp = uint8(watermarkedImage_Uint8);
    SH = Sharpen(temp);
    %[watermark_1_extracted] = watermark_extraction_1(SH, RoiMap, Uw1, Vw1, key1);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(SH) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n Sharpen ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
        fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OI,OImage));

    %resize
    [h c] = size(OI);
    reimg = imresize(watermarkedImage_Uint8,[64 64]);
    reimg = imresize(reimg,[h c]);
    %[watermark_1_extracted] = watermark_extraction_1(reimg, RoiMap, Uw1, Vw1, key1);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(reimg) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n resize ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OI,OImage));

    %rotation 
    rotationImageAttacked = imrotate(watermarkedImage_Uint8, 70, 'crop');
    %[watermark_1_extracted] = watermark_extraction_1(rotationImageAttacked, RoiMap, Uw1, Vw1, key1);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(rotationImageAttacked) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n rotation ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OI,OImage));

    %contrast adjustment
    contrastImage = imadjust(watermarkedImage_Uint8, [0 0.8], [0 1]);
    %[watermark_1_extracted] = watermark_extraction_1(contrastImage, RoiMap, Uw1, Vw1, key1);
   % [watermark_1_extracted, watermark_2_extracted] = watermark_extraction(contrastImage);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(contrastImage) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n contrast adjustment ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OImage,OI));
    
    %CROP Attack
    test= crop(watermarkedImage_Uint8,4);
    %[watermark_1_extracted] = watermark_extraction_1(contrastImage, RoiMap, Uw1, Vw1, key1);
    %[watermark_1_extracted, watermark_2_extracted] = watermark_extraction(test);
    % Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        watermarkedImage_Dung = double(test) + watermarkedImage_Error; 
        LS = liftwave('cdf2.2','Int2Int');
        [CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);
        [c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
        [CD_OI, watermark_Sau] = extracting_Shift0_dchiam_IWT_(Denta, m, Check, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);
        OImage = ilwt2(CA,CH,CV,CD_OI,LS);
    dc = decode_qr(watermark_Sau);
    fprintf(fid,'\r\n Crop1/4 ');
    fprintf(fid,'NC: %12.8f ',NC(w,watermark_Sau));
    if dc
       fprintf(fid,'Rut duoc-%s \t',dc);
    end
    fprintf(fid,'PSNR: %12.8f',PSNR(OI,OImage));
    
    fclose(fid);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   IWT


% Extracting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%watermarkedImage_Dung = double(watermarkedImage_Uint8) + watermarkedImage_Error; 
%LS = liftwave('cdf2.2','Int2Int');
%[CA,CH,CV,CD_Modi_] = lwt2(double(watermarkedImage_Dung),LS);

%[c_Cross,r_Cross,uh_Cross,u_Cross] = crossset(CD_Modi_);
%[CD_OI, watermark] = extracting_Shift0_dchiam(Denta, m, CD_Modi_, size_W,KEY,c_Cross,r_Cross,uh_Cross,u_Cross);

%OImage = ilwt2(CA,CH,CV,CD_OI,LS);