--Starry-Eyes Spatial Dragon
function c101010434.initial_effect(c)
	--attack banish
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c101010434.bancon)
	ae1:SetTarget(c101010434.bantg)
	ae1:SetOperation(c101010434.banop)
	c:RegisterEffect(ae1)
	if not spatial_check then
		spatial_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c101010434.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c101010434.spatial=true
function c101010434.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,500)
	Duel.CreateToken(1-tp,500)
end
function c101010434.bancon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c101010434.atkfilter(c,atk)
	local gr=c:IsAbleToGrave()
	local def=c:GetBaseDefense()
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and ((atk>=c:GetBaseAttack() and gr) or (atk==def or (atk>def and gr)))
end
function c101010434.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and c101010434.atkfilter(chkc,c:GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(c101010434.atkfilter,tp,0,LOCATION_REMOVED,1,nil,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010434.atkfilter,tp,0,LOCATION_REMOVED,1,1,nil,c:GetAttack())
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	local m=_G["c"..g:GetFirst():GetCode()]
	if not m or not m.spatial then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function c101010434.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and tc:GetBaseAttack()==c:GetAttack() then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
		local m=_G["c"..tc:GetCode()]
		if tc:GetBaseDefense()>=c:GetAttack() or (m and m.spatial) then return end
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
