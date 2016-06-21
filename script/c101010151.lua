--襲雷属性－フレイーム
local id,ref=GIR()
function ref.start(c)
--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(ref.descon)
	e2:SetOperation(ref.desop)
	c:RegisterEffect(e2)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	if not ref.global_check then
		ref.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabel(id)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(e1,0)
	end
	--burn
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetRange(0x32)
	e1:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(ref.con)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
end
function ref.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local atk=0
	if tc:IsFaceup() then atk=tc:GetAttack() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=0
		if tc:IsFaceup() then atk=tc:GetAttack() end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
