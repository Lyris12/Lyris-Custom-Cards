--created & coded by Lyris
--制勝銘
function c101010226.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101010226)
	e1:SetTarget(c101010226.target)
	e1:SetOperation(c101010226.operation)
	c:RegisterEffect(e1)
end
function c101010226.filter(c)
	if c:IsType(TYPE_PENDULUM) and c:IsHasEffect(10001000) and not c:IsAbleToDeck() then return false end
	return c:IsFaceup() and c:IsSetCard(0x50b)
end
function c101010226.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010226.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010226.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101010226.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local c=g:GetFirst()
	if c:IsType(TYPE_PENDULUM) and c:IsHasEffect(10001000) then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	else
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800)
	end
end
function c101010226.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_PENDULUM) and tc:IsHasEffect(10001000) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		elseif Duel.Damage(tp,800,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c101010226.effect)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c101010226.effect(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e:GetHandler():RegisterEffect(e1)
end
