--サイバード
function c101010146.initial_effect(c)
--equip
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(c101010146.eqtg)
	e0:SetOperation(c101010146.eqop)
	c:RegisterEffect(e0)
	--Do Not Remove
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EFFECT_REMOVE_TYPE)
	e20:SetValue(TYPE_UNION)
	c:RegisterEffect(e20)
	--be material
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c101010146.matcon)  
	e4:SetTarget(c101010146.mattg)
	e4:SetOperation(c101010146.matop)
	c:RegisterEffect(e4)
	--synlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c101010146.synlimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94988063,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101010146.spcon)
	e2:SetTarget(c101010146.sptg)
	e2:SetOperation(c101010146.spop)
	c:RegisterEffect(e2)
	--lvchange
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(94988063,1))
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetCondition(c101010146.lvcon)
	e3:SetValue(2)
	c:RegisterEffect(e3)
end
function c101010146.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_MACHINE)
end
function c101010146.cfilter(c)
return c:IsFaceup() and c:GetCode()==70095154
end
function c101010146.spcon(e,tp,eg,ep,ev,re,r,rp)
return eg:IsExists(c101010146.cfilter,1,nil)
end
function c101010146.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010146.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c:IsRelateToEffect(e) then
Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
end
function c101010146.lvfilter(c)
return c:IsFaceup() and c:GetCode()==70095154
end
function c101010146.lvcon(e)
return Duel.IsExistingMatchingCard(c101010146.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101010146.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetCode()~=101010146
end
function c101010146.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101010146.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101010146.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c101010146.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,c,tc,true)
		--Add Equip limit
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c101010146.eqlimit)
		c:RegisterEffect(e2)
	end
end
function c101010146.eqlimit(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c101010146.matcon(e)
	local c=e:GetHandler()
	local tc=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and tc and tc:IsReason(8442)
end
function c101010146.matfilter(c,e,tp)
	return c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010146.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010146.matfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010146.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010146.matfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
