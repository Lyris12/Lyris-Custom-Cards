--襲雷竜－光
function c101010091.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101010091.regcon)
	e3:SetOperation(c101010091.regop)
	c:RegisterEffect(e3)
	local e1=e3:Clone()
	e1:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010091.con)
	e2:SetOperation(c101010091.op)
	c:RegisterEffect(e2)
end
function c101010091.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c101010091.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--While this card is banished or in the Graveyard because it was destroyed, "Blitzkrieg" Spell/Trap Cards you control cannot be destroyed card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetTarget(c101010091.indtg)
	e1:SetValue(c101010091.indval)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c101010091.indfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsReason(REASON_EFFECT) and c:IsSetCard(0x167)
end
function c101010091.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp~=tp and eg:IsExists(c101010091.indfilter,1,nil,tp) end
	return true
end
function c101010091.indval(e,c)
	return c101010091.indfilter(c,e:GetHandlerPlayer())
end
function c101010091.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c101010091.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
