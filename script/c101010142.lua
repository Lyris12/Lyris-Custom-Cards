--F・HEROドゥオガイ
local id,ref=GIR()
function ref.start(c)
--ritual tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(ref.rlv)
	c:RegisterEffect(e1)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(ref.actcon)
	e2:SetTarget(ref.acttg)
	e2:SetOperation(ref.act)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e3)
end
function ref.rlv(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x8) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function ref.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(id)~=0
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if ev~=0 then
			local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if ef~=nil and ef:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then Card.ReleaseEffectRelation(c,ef) end
		end
		ref.after(e,tp)
	end
end
function ref.filter(c)
	return c:IsSetCard(0x8) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function ref.after(e,tp)
	local g=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
