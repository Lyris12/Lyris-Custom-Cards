--機光襲雷－アフターニューン
function c101010083.initial_effect(c)
	--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010083.descon)
	e2:SetOperation(c101010083.desop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,101010083)
	e3:SetOperation(c101010083.regop)
	c:RegisterEffect(e3)
end
function c101010083.atcon(e,c)
	return c==e:GetHandler()
end
function c101010083.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010083.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010083.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c101010083.damcon)
	e3:SetOperation(c101010083.damop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c101010083.filter(c)
	return c:IsSetCard(0x167)
end
function c101010083.damcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c101010083.filter,1,nil)
end
function c101010083.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101010083)
	--local g=eg:Filter(c101010083.filter,nil)
	local atk=0
	local tatk=0
	local tc=eg:GetFirst()
	while tc do
		if c101010083.filter(tc) then
			if tc:IsType(TYPE_MONSTER) then tatk=math.floor(tc:GetBaseAttack()/2)+500 else tatk=500 end
			atk=atk+tatk
		end
		tc=eg:GetNext()
	end
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end
