--Cyber Apollo Dragon/Assault Mode
function c101010139.initial_effect(c)
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--copy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c101010139.cpcost)
	e5:SetTarget(c101010139.cptg)
	e5:SetOperation(c101010139.cpop)
	c:RegisterEffect(e5)
	--Special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c101010139.spcon)
	e6:SetTarget(c101010139.sptg)
	e6:SetOperation(c101010139.spop)
	c:RegisterEffect(e6)
	--assault mode activate
	if not c101010139.global_check then
		c101010139.global_check=true
		local ama=Effect.CreateEffect(c)
		ama:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ama:SetCode(EVENT_ADJUST)
		ama:SetOperation(c101010139.amaop)
		Duel.RegisterEffect(ama,0)
	end
end
function c101010139.atktg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c101010139.cpfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c101010139.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010139.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010139.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c101010139.filter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c101010139.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	end
	local g=Duel.GetMatchingGroup(c101010139.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101010139.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c101010139.spfilter(c,e,tp)
	return c:IsCode(101010139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010139.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010139.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010139.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010139.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010139.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010139.amafilter(c)
	return c:GetOriginalCode()==80280737
end
function c101010139.amaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c101010139.amafilter,c:GetControler(),0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(101010139)==0 then
			--Activate
			local e1=Effect.CreateEffect(tc)
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e1:SetDescription(aux.Stringid(101010139,0))
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
			e1:SetCost(c101010139.cost)
			e1:SetTarget(c101010139.tg)
			e1:SetOperation(c101010139.op)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(101010139,0,0,1)  
		end
		tc=g:GetNext()
	end
end
function c101010139.filter1(c,e,tp)
	return c:IsCode(101010139) and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c101010139.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c101010139.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101010139.filter1,1,nil,e,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c101010139.filter1,1,1,nil,e,tp)
	Duel.Release(rg,REASON_COST)
end
function c101010139.filter2(c,e,tp)
	return c:IsCode(101010139) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101010139.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010139.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(c101010139.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		tc:CompleteProcedure()
	end
end
