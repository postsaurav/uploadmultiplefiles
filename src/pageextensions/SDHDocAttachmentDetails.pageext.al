pageextension 50000 "SDH Doc. Attachment Details" extends "Document Attachment Details"
{
    actions
    {
        addfirst(processing)
        {
            fileuploadaction(UploadMultipleFiles)
            {
                Caption = 'Upload Multiple Files';
                ApplicationArea = All;
                AllowMultipleFiles = true;
                Image = Import;
                trigger OnAction(Files: List of [FileUpload])
                var
                    CurrentFile: FileUpload;
                    FileInStream: InStream;
                begin
                    foreach CurrentFile in Files do begin
                        CurrentFile.CreateInStream(FileInStream, TEXTENCODING::UTF8);
                        SDHInitiateUploadFile(FileInStream, CurrentFile.FileName);
                    end;
                end;
            }
        }
        addfirst(Promoted)
        {
            actionref(UploadMultipleFiles_Promoted; UploadMultipleFiles) { }
        }
    }

    local procedure SDHInitiateUploadFile(var FileInStream: InStream; FileName: Text)
    var
        DocumentAttachment: Record "Document Attachment";
        TempBlob: Codeunit "Temp Blob";
        FileOutStream: OutStream;
    begin
        TempBlob.CreateOutStream(FileOutStream);
        CopyStream(FileOutStream, FileInStream);
        if FileName <> '' then
            DocumentAttachment.SaveAttachment(FromRecRef, FileName, TempBlob);
        CurrPage.Update(true);
    end;

}
