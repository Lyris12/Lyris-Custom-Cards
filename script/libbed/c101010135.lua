--短期流罪
local id,ref=GIR()
function ref.start(c)
local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_CONTROL)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(ref.target)
	e0:SetOperation(ref.activate)
	c:RegisterEffect(e0)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.GetTurnPlayer()~=tp then
			if not Duel.GetControl(tc,1-tp,EVENT_BATTLE_START,1) then
				if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		else
			if not Duel.GetControl(tc,1-tp,PHASE_END,1) then
				if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end
