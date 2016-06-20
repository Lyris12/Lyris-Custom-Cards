--Clarissa, Queen of Stellar Vine #2
local id,ref=GIR()
function ref.start(c)
c:EnableCounterPermit(0x3001)
	--add counter
	local ae3=Effect.CreateEffect(c)
	ae3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ae3:SetCode(EVENT_REMOVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCondition(ref.con)
	ae3:SetOperation(ref.acop)
	c:RegisterEffect(ae3)
	--Evolute Counter
	local ae0=Effect.CreateEffect(c)
	ae0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae0:SetCode(101010600)
	ae0:SetOperation(ref.eop)
	c:RegisterEffect(ae0)
	--survival
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ae1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ae1:SetCode(EFFECT_DESTROY_REPLACE)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetTarget(ref.reptg)
	ae1:SetOperation(ref.repop)
	c:RegisterEffect(ae1)
	--banish
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_QUICK_O)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCode(EVENT_FREE_CHAIN)
	ae2:SetCountLimit(1)
	ae2:SetCondition(ref.con)
	ae2:SetCost(ref.cost)
	ae2:SetOperation(ref.op)
	c:RegisterEffect(ae2)
	--special summon (Do Not Remove)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	e1:SetValue(8751)
	c:RegisterEffect(e1)
	--counter (Do Not Remove)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(ref.addc)
	c:RegisterEffect(e2)
	--counter (Do Not Remove)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101010600,1))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(ref.acos)
	e4:SetTarget(ref.addct2)
	e4:SetOperation(ref.addc2)
	c:RegisterEffect(e4)
	--cannot Negate (Do Not Remove)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(ref.con)
	e5:SetValue(ref.efilter)
	c:RegisterEffect(e5)
	--cannot be XYZ (Do Not Remove)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	--cannot special summon (Do Not Remove)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e7)
	--type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_XYZ)
	c:RegisterEffect(e3)
end
function ref.rfilter1(c)
	return c:GetLevel()==4 and c:IsRace(RACE_FAIRY)
end
function ref.rfilter2(c)
	return c:GetLevel()==4 and c:IsAttribute(ATTRIBUTE_WATER)
end
function ref.spcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(ref.rfilter1,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>0 then
		local g2=Duel.IsExistingMatchingCard(ref.rfilter2,tp,LOCATION_MZONE,0,1,g1:GetFirst(),nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g2
	end
	return false
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g2=Duel.SelectMatchingCard(tp,ref.rfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,ref.rfilter2,tp,LOCATION_MZONE,0,1,1,g2:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+8751)
end
function ref.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x88,8)
end
function ref.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function ref.acos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,ref.cfilter,1,1,REASON_COST)
end
function ref.addct2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x88)
end
function ref.addc2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x88,3)
	end
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x88)>2
end
function ref.efilter(e,te)
	return te:IsHasCategory(CATEGORY_NEGATE+CATEGORY_DISABLE)
end
function ref.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(Card.IsSetCard,1,c,0x785e) then
		c:AddCounter(0x3001,1)
		if c:GetCounter(0x3001)==3 then
			Duel.RaiseSingleEvent(c,101010600,e,0,0,tp,0)
		end
	end
end
function ref.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x3001,3,REASON_EFFECT)
	c:AddCounter(0x88,1)
end
function ref.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x88)>2 end
	return Duel.SelectYesNo(tp,aux.Stringid(101010600,0))
end
function ref.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x88,1,REASON_EFFECT)
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,2,REASON_COST)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x785e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil):RandomSelect(tp,1)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and bit.band(tc:GetFirst():GetOriginalType(),TYPE_FUSION)==TYPE_FUSION and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
