local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local select = select
local hooksecurefunc = hooksecurefunc

local function HandleTalentFrameDialog(dialog)
	if not dialog then return end

	dialog:StripTextures()
	dialog:CreateBackdrop('Transparent')
	if dialog.AcceptButton then S:HandleButton(dialog.AcceptButton) end
	if dialog.CancelButton then S:HandleButton(dialog.CancelButton) end
	if dialog.DeleteButton then S:HandleButton(dialog.DeleteButton) end

	S:HandleEditBox(dialog.NameControl.EditBox)
	dialog.NameControl.EditBox.backdrop:SetPoint('TOPLEFT', -5, -10)
	dialog.NameControl.EditBox.backdrop:SetPoint('BOTTOMRIGHT', 5, 10)
end

function S:Blizzard_ClassTalentUI()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.talent) then return end

	local ClassTalentFrame = _G.ClassTalentFrame
	S:HandlePortraitFrame(ClassTalentFrame)
	ClassTalentFrame.TalentsTab.BlackBG:SetAlpha(0)
	ClassTalentFrame.TalentsTab.BottomBar:SetAlpha(0)

	S:HandleButton(ClassTalentFrame.TalentsTab.ApplyButton)
	S:HandleDropDownBox(ClassTalentFrame.TalentsTab.LoadoutDropDown.DropDownControl.DropDownMenu)

	ClassTalentFrame.TalentsTab.ClassCurrencyDisplay.CurrencyLabel:FontTemplate(nil, 18)
	ClassTalentFrame.TalentsTab.ClassCurrencyDisplay.CurrencyAmount:FontTemplate(nil, 26)

	ClassTalentFrame.TalentsTab.SpecCurrencyDisplay.CurrencyLabel:FontTemplate(nil, 18)
	ClassTalentFrame.TalentsTab.SpecCurrencyDisplay.CurrencyAmount:FontTemplate(nil, 26)

	S:HandleEditBox(ClassTalentFrame.TalentsTab.SearchBox)
	ClassTalentFrame.TalentsTab.SearchBox.backdrop:SetPoint('TOPLEFT', -4, -5)
	ClassTalentFrame.TalentsTab.SearchBox.backdrop:SetPoint('BOTTOMRIGHT', 0, 5)
	ClassTalentFrame.TalentsTab.SearchPreviewContainer:StripTextures()
	ClassTalentFrame.TalentsTab.SearchPreviewContainer:CreateBackdrop('Transparent')

	for i = 1, 2 do
		local tab = select(i, ClassTalentFrame.TabSystem:GetChildren())
		S:HandleTab(tab)
	end

	hooksecurefunc(ClassTalentFrame.SpecTab, 'UpdateSpecFrame', function(frame)
		for specContentFrame in frame.SpecContentFramePool:EnumerateActive() do
			if not specContentFrame.isSkinned then
				S:HandleButton(specContentFrame.ActivateButton)

				if specContentFrame.SpellButtonPool then
					for button in specContentFrame.SpellButtonPool:EnumerateActive() do
						button.Ring:Hide()
						S:HandleIcon(button.Icon, true) -- Hide Mask
					end
				end

				specContentFrame.isSkinned = true
			end
		end
	end)

	local ImportDialog = _G.ClassTalentLoadoutImportDialog
	if ImportDialog then
		HandleTalentFrameDialog(ImportDialog)
		ImportDialog.ImportControl.InputContainer:StripTextures()
		ImportDialog.ImportControl.InputContainer:CreateBackdrop('Transparent')
	end

	local CreateDialog = _G.ClassTalentLoadoutCreateDialog
	if CreateDialog then
		HandleTalentFrameDialog(CreateDialog)
	end

	local EditDialog = _G.ClassTalentLoadoutEditDialog
	if EditDialog then
		HandleTalentFrameDialog(EditDialog)

		local editbox = EditDialog.LoadoutName
		if editbox then
			S:HandleEditBox(editbox)
			editbox.backdrop:SetPoint('TOPLEFT', -5, -5)
			editbox.backdrop:SetPoint('BOTTOMRIGHT', 5, 5)
		end

		local check = EditDialog.UsesSharedActionBars
		if check then
			S:HandleCheckBox(check.CheckButton)
			check.CheckButton.backdrop:SetInside(6, 6)
		end
	end

	--PVP
	ClassTalentFrame.TalentsTab.PvPTalentList:StripTextures()
	ClassTalentFrame.TalentsTab.PvPTalentList:CreateBackdrop()
	ClassTalentFrame.TalentsTab.PvPTalentList.backdrop:SetFrameStrata(ClassTalentFrame.TalentsTab.PvPTalentList:GetFrameStrata())
	ClassTalentFrame.TalentsTab.PvPTalentList.backdrop:SetFrameLevel(2000)
end

S:AddCallbackForAddon('Blizzard_ClassTalentUI')
