tableextension 50100 "PVS Production Analysis SellTo" extends "PrintVis Production Analysis"
{
    trigger OnBeforeInsert()
    var
        ProductionAnalysisSellTo: Codeunit "PVS Prod. Analysis SellTo";
    begin
        ProductionAnalysisSellTo.SyncSellToFields(Rec);
    end;

    trigger OnBeforeModify()
    var
        ProductionAnalysisSellTo: Codeunit "PVS Prod. Analysis SellTo";
    begin
        ProductionAnalysisSellTo.SyncSellToFields(Rec);
    end;

    fields
    {
        field(50100; "Sell-to No."; Code[20])
        {
            Caption = 'Sell-to No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Sell-to Name"; Text[100])
        {
            Caption = 'Sell-to Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    modify("PrintVis Order No.")
    {
        trigger OnAfterValidate()
        var
            ProductionAnalysisSellTo: Codeunit "PVS Prod. Analysis SellTo";
        begin
            ProductionAnalysisSellTo.SyncSellToFields(Rec);
        end;
    }
}
