--Cyber End Grand Dragon
local id,ref=GIR()
function ref.start(c)
	--A Fusion Summon of this card can only be done with the above Fusion Materials.
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,70095154,3,false,false)
	--You cannot Xyz Summon using Xyz Monsters as Xyz Material. This effect cannot be negated.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(ref.nox)
	e1:SetValue(ref.xyzlimit)
	c:RegisterEffect(e1)
	--At the end of the Damage Step, if this card attacked: You can send 1 "Cyber Dragon" monster from your Deck to the Graveyard; this card can make 1 additional attack this turn, and if you do, it gains 500 ATK until the end of this turn. You can only use this effect of "Cyber End Grand Dragon" up to twice per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCountLimit(2,id)
	e2:SetCondition(ref.con)
	e2:SetCost(ref.cost)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
end
function ref.nox(e,c)
	return c:IsType(TYPE_XYZ)
end
function ref.xyzlimit(e,c)
	if not c then return false end
	return c:GetSummonPlayer()==e:GetHandlerPlayer()
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function ref.tgfilter(c)
	return c:IsSetCard(0x1093) and c:IsAbleToGraveAsCost()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(id)
	if not ct then ct=0 end
	if c:IsRelateToEffect(e) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(500)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct+1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
