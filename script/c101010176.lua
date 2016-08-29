--リレー・アース
function c101010176.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010176.mttg1)
	e1:SetOperation(c101010176.matop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101010176)
	e1:SetCost(c101010176.cost)
	e2:SetTarget(c101010176.mattg)
	e2:SetOperation(c101010176.matop)
	c:RegisterEffect(e2)
end
c101010176.earth_enforcer_list=true
function c101010176.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xeeb) and c:IsType(TYPE_XYZ)
end
function c101010176.matfilter(c)
	return c:IsSetCard(0xeeb) and c:IsAbleToRemoveAsCost()
end
function c101010176.mttg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010176.xyzfilter(c) end
	if chk==0 then return true end
	if Duel.GetFlagEffect(tp,101010176)==0 and Duel.IsExistingMatchingCard(c101010176.matfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c101010176.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,2,nil,0xeeb) and Duel.SelectYesNo(tp,aux.Stringid(101010176,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Remove(Duel.SelectMatchingCard(tp,c101010176.matfilter,tp,LOCATION_GRAVE,0,1,1,nil),POS_FACEUP,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c101010176.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
		e:GetHandler():RegisterFlagEffect(101010176,RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
	else
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c101010176.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010176.matfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,101010176)==0 end
	Duel.RegisterFlagEffect(tp,101010176,RESET_PHASE+PHASE_END,0,1)
	Duel.Remove(Duel.SelectMatchingCard(tp,c101010176.matfilter,tp,LOCATION_GRAVE,0,1,1,nil),POS_FACEUP,REASON_COST)
end
function c101010176.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010176.xyzfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(101010176)==0
		and Duel.IsExistingTarget(c101010176.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,2,nil,0xeeb) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010176.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010176.matop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0xeeb)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
