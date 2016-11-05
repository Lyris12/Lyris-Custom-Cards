--F・HEROドゥオガイ
function c101010142.initial_effect(c)
	--ritual tribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c101010142.rlv)
	c:RegisterEffect(e0)
	--triple tribute (special)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c101010142.spop)
	c:RegisterEffect(e1)
	--activate
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(101010142,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,101010142)
	e2:SetTarget(c101010142.acttg)
	e2:SetOperation(c101010142.act)
	c:RegisterEffect(e2)
	--triple tribute (normal)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e4:SetValue(c101010142.ttval)
	c:RegisterEffect(e4)
end
function c101010142.rlv(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xf7a) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c101010142.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010142.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010142.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf7a) and c:IsAbleToHand()
end
function c101010142.act(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010142.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101010142.tttg(c)
	return c:IsCode(17132130) or c:IsCode(83965310)
end
function c101010142.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101010142,RESET_EVENT+0x1ff0000,0,1)
	--triple tribute
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(101010142,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101010142.ttcon)
	e1:SetOperation(c101010142.ttop)
	e1:SetValue(c101010142.tri3)
	local tg=Duel.GetMatchingGroup(c101010142.tttg,tp,0xff,0xff,nil,4,tp)
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
function c101010142.tri3(e,c)
	if c:IsCode(17132130) then
		return 1
	else return 0 end
end
function c101010142.ttval(e,c)
	if e:GetHandler():GetSummonType()~=SUMMON_TYPE_SPECIAL then return false end
	return c:IsRace(RACE_WARRIOR)
end
c101010142.after=function(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010142.filter,tp,LOCATION_DECK,0,1,nil)end
	c101010142.act(e,tp)
end
