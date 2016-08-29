--F・HEROドゥオガイ
function c101010142.initial_effect(c)
--ritual tribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c101010142.rlv)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010142,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101010142.actcon)
	e2:SetTarget(c101010142.acttg)
	e2:SetOperation(c101010142.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101010142,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e4:SetValue(c101010142.ttval)
	c:RegisterEffect(e4)
end
function c101010142.rlv(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x8) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c101010142.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010091)~=0
end
function c101010142.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010142.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		c101010142.after(e,tp)
	end
end
function c101010142.filter(c)
	return c:IsSetCard(0x8) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c101010142.tttg(c)
	return c:IsCode(17132130) or c:IsCode(83965310)
end
function c101010142.after(e,tp)
	e:GetHandler():RegisterFlagEffect(101010142,RESET_EVENT+0x1ff0000,0,1)
	--triple tribute
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(101010142,2))
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
	local g=Duel.GetMatchingGroup(c101010142.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
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
	if e:GetHandler():GetSummonLocation()~=LOCATION_SZONE then return false end
	return c:IsRace(RACE_WARRIOR)
end