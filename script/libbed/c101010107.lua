--FFD－メテオ
local id,ref=GIR()
function ref.start(c)
--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(ref.aclimit)
	e2:SetCondition(ref.actcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(ref.reptg)
	e0:SetValue(ref.repval)
	c:RegisterEffect(e0)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCost(ref.dcost)
	e5:SetTarget(ref.dtg)
	e5:SetOperation(ref.dop)
	c:RegisterEffect(e5)
	--Special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetTarget(ref.sptg)
	e6:SetOperation(ref.spop)
	c:RegisterEffect(e6)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,ref.ffilter1,ref.ffilter2,true)
end
function ref.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) or (c:IsHasEffect(101010560) and not c:IsLocation(LOCATION_DECK))
end
function ref.ffilter2(c)
	return c:IsRace(RACE_WARRIOR+RACE_WINDBEAST) or (c:IsHasEffect(101010576) and not c:IsLocation(LOCATION_DECK))
end
function ref.aclimit(e,re,tp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:GetHandler():IsLocation(LOCATION_HAND)) and not re:GetHandler():IsImmuneToEffect(e)
end
function ref.actcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsHasEffect(101010552)
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa88)
end
function ref.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,ref.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,ref.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function ref.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function ref.dop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function ref.spfilter(c,e,tp)
	return c:IsSetCard(0xa88) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ref.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:GetAttack()>0 and c:IsReason(REASON_BATTLE)
end
--If this card destroys a monster by battle, inflict damage to your opponent equal to half its ATK, also, move it to a possible location at random, instead.
function ref.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and eg:IsExists(ref.repfilter,1,nil,tp) end
	local tc=eg:GetFirst()
	local atk=tc:GetAttack()
	if Duel.Damage(1-tp,atk/2,REASON_EFFECT+REASON_REPLACE) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		return true
		else return false
	end
end
function ref.repval(e,c)
	return ref.repfilter(c,e:GetHandlerPlayer())
end
