--サイバーネトワークのウイルス
function c101010179.initial_effect(c)
--replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010179.condition)
	e1:SetTarget(c101010179.target)
	e1:SetOperation(c101010179.operation)
	c:RegisterEffect(e1)
end
function c101010179.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsOnField()
end
function c101010179.filter(c)
	return c:IsType(TYPE_XYZ)
end
function c101010179.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c101010179.filter,tp,LOCATION_ONFIELD,0,1,e:GetLabelObject()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET) 
	Duel.SelectTarget(tp,c101010179.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetLabelObject())
end
function c101010179.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetOverlayCount()
		if g>0 then
			tc:RemoveOverlayCard(tp,g,g,REASON_EFFECT)
			Duel.BreakEffect()
		end
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
