--created by Hintin
--coded by Lyris
--Red Soldier
function c101020012.initial_effect(c)
	c:SetSPSummonOnce(101020012)
	--If you control exactly 1 Warrior-Type monster, you can Special Summon this card (from your hand).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101020012.spcon)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c101020012.efcon)
	e2:SetOperation(c101020012.efop)
	c:RegisterEffect(e2)
end
function c101020012.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c101020012.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c101020012.filter,tp,LOCATION_MZONE,0,nil)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c101020012.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c101020012.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsRace(RACE_WARRIOR) then return end
	--● If it is Xyz Summoned: Excavate the top card if your Deck, then if it is a Warrior-Type monster, add it to your hand.
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(101020012,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101020012.drcon)
	e1:SetTarget(c101020012.drtg)
	e1:SetOperation(c101020012.drop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c101020012.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c101020012.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c101020012.drfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c101020012.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,1)
	local g=Duel.GetDecktopGroup(p,1)
	if c101020012.drfilter(g:GetFirst()) then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,g)
		Duel.ShuffleHand(p)
	end
end
