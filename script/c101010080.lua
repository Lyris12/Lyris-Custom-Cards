--created & coded by Lyris
--ＳＳＤーサイクロン
function c101010080.initial_effect(c)
--bounce
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DAMAGE_STEP_END)
	e0:SetCondition(c101010080.rtcon)
	e0:SetTarget(c101010080.rttg)
	e0:SetOperation(c101010080.rtop)
	c:RegisterEffect(e0)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c101010080.aclimit)
	e1:SetCondition(c101010080.actcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101010080.spscon)
	e2:SetOperation(c101010080.spsop)
	c:RegisterEffect(e2)
end
function c101010080.ffilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsFaceup() and c:IsOnField())) and c:IsAbleToGraveAsCost()
end
function c101010080.spscon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c101010080.ffilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	return mg:CheckWithSumEqual(Card.GetLevel,c:GetOriginalLevel(),1,99,nil)
end
function c101010080.spsop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mat=mg:SelectWithSumEqual(tp,Card.GetLevel,c:GetOriginalLevel(),1,99,nil)
	Duel.SendtoGrave(mat,nil,2,REASON_COST)
end
function c101010080.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c101010080.filter(c,e)
	return c:IsAbleToHand() and not c:IsImmuneToEffect(e)
end
function c101010080.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c101010080.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101010080.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	g:RemoveCard(c)
	local ck1=g:GetCount()
	local ck2=Duel.SendtoHand(g,nil,REASON_EFFECT)
	if ck2<ck1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		c:RegisterEffect(e1)
	end
end
function c101010080.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
end
function c101010080.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c101010080.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
