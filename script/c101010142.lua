--created & coded by Lyris
--フェイツ・ドゥオガイ
function c101010142.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c101010142.rlv)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c101010142.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e2:SetValue(c101010142.ttval)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101010142)
	e1:SetCondition(c101010142.condition)
	e1:SetTarget(c101010142.target)
	e1:SetOperation(c101010142.operation)
	c:RegisterEffect(e1)
end
function c101010142.rlv(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xf7a) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c101010142.tttg(c)
	return c:IsCode(83965310)
end
function c101010142.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101010142,RESET_EVENT+0x1ff0000,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(101010142,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101010142.ttcon)
	e1:SetOperation(c101010142.ttop)
	local tg=Duel.GetMatchingGroup(c101010142.tttg,tp,0xff,0xff,nil)
	local c=tg:GetFirst()
	local e5=nil
	while c do
		if c:GetFlagEffect(101010142)==0 then
			e5=e1:Clone()
			c:RegisterEffect(e5)
			c:RegisterFlagEffect(101010142,0,0,1)
		end
		c=tg:GetNext()
	end
end
function c101010142.ttfilter(c)
	return c:GetOriginalCode()==101010142 and c:IsReleasable() and c:GetFlagEffect(101010142)~=0
end
function c101010142.ttcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c101010142.ttfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101010142.ttop(e,tp,eg,ep,ev,re,r,rp,c,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c101010142.ttfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c101010142.ttval(e,c)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_SPECIAL then return false end
	return c:IsRace(RACE_WARRIOR)
end
function c101010142.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
		local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
		return (pc1 and pc1:IsSetCard(0xf7a)) or (pc2 and pc2:IsSetCard(0xf7a))
	end
	return c:GetSummonLocation()==LOCATION_HAND or re:GetHandler():IsSetCard(0xf7a)
end
function c101010142.filter(c)
	return c:IsSetCard(0xf7a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=101010142
end
function c101010142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010142.filter,tp,LOCATION_DECK,0,1,nil) end
	e:SetCategory(CATEGORY_TOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010142.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010142.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
