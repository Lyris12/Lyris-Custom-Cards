--created & coded by Lyris
--LCmシャートルーズ
function c101010237.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101010237.tg)
	e1:SetOperation(c101010237.op)
	c:RegisterEffect(e1)
end
function c101010237.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x613) and c:IsAbleToGrave()
end
function c101010237.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101010237.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101010237.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local def=g:GetFirst():GetTextDefense()
	if def<0 then def=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,def)
end
function c101010237.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:GetDefense()>0 then
		Duel.BreakEffect()
		Duel.Recover(1-tp,tc:GetDefense(),REASON_EFFECT)
	end
end
