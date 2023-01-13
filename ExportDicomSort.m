%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Authors: Deep B. Gandhi
%Last modified date: 11/23/21
%Last modified by: Deep B. Gandhi
%Purpose: To sort and export unorganized DICOM data exported from PACS into individual
%DICOM series.
%Inputs: Full file path of the directory conatining the unorganized DICOM
%Data
%Outputs: A directory titled 'SortedData' containing folders for each DICOM
%data series
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function status = ExportDicomSort(~)

tic
PatientDataDir = pwd;
cd(PatientDataDir)
PatientMRI = dicomCollection(PatientDataDir, 'IncludeSubfolders', false);
[Row,~] = size(PatientMRI);
ScanType = PatientMRI.SeriesDescription;
ScanFiles = PatientMRI.Filenames;
if ~isfolder('SortedData')
    mkdir('SortedData')
end
destination = horzcat(PatientDataDir,'\SortedData');
cd(destination)

for i = 1:Row
    scan = ScanType(i);
    files = ScanFiles{i,1};
    if ~exist(scan,'dir')
        scan = regexprep(scan,'[^a-zA-Z0-9]','_');
        dest_str = "%s\\%02d_%s";
        dest_str_final = sprintf(dest_str,destination,i,scan);
        mkdir(dest_str_final)
    end
    for j = 1:numel(files)
        copyfile(files(j),dest_str_final)
    end
end
disp('Sorting and copying the files successful! Now deleting the duplicate files!')
status = 1;
cd(PatientDataDir)
delete('*.dcm');

toc
end