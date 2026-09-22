tableextension 50100 "PVS Production Analysis SellTo" extends "PrintVis Production Analysis"
{
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
        modify("PrintVis Order No.")
        {
            trigger OnAfterValidate()
            var
                ProductionAnalysisSellTo: Codeunit "PVS Prod. Analysis SellTo";
            begin
                if ProductionAnalysisSellTo.SyncSellToFields(Rec) and not Rec.IsTemporary() and not IsNullGuid(Rec.SystemId) then
                    Rec.Modify(true);
            end;
        }
    }
}
