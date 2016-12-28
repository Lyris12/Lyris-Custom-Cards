--created & coded by Lyris
--機光襲雷 アーフタヌーン
function c101010030.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010030.descon)
	e2:SetOperation(c101010030.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,101010030)
	e3:SetOperation(c101010030.regop)
	c:RegisterEffect(e3)
end
function c101010030.atcon(e,c)
	return c==e:GetHandler()
end
function c101010030.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010030.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c101010030.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c101010030.damcon)
	e3:SetOperation(c101010030.damop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c101010030.filter(c)
	return c:IsSetCard(0x167)
end
function c101010030.damcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c101010030.filter,1,nil)
end
function c101010030.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101010030)
	local atk=0
	local tatk=0
	local tc=eg:GetFirst()
	while tc do
		if c101010030.filter(tc) then
			if tc:IsType(TYPE_MONSTER) then tatk=math.floor(tc:GetBaseAttack()/2)+500 else tatk=500 end
			atk=atk+tatk
		end
		tc=eg:GetNext()
	end
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end
