--サイバー・アポロ・ドラゴン／バスター
function c101010013.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,10000000)
	e3:SetCondition(c101010013.pscon)
	e3:SetOperation(c101010013.psop)
	e3:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010013.activate)
	c:RegisterEffect(e1)
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101010013.splimit)
	c:RegisterEffect(e1)
	--atk (spell)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101010013.atktg)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--move to Pendulum Scale (monster)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetDescription(aux.Stringid(101010013,0))
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c101010013.pencost)
	e5:SetTarget(c101010013.pentg)
	e5:SetOperation(c101010013.penop)
	c:RegisterEffect(e5)
	--Special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(101010013,1))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c101010013.spcon)
	e6:SetTarget(c101010013.sptg)
	e6:SetOperation(c101010013.spop)
	c:RegisterEffect(e6)
	--assault mode activate
	if not c101010013.global_check then
		c101010013.global_check=true
		local ama=Effect.CreateEffect(c)
		ama:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ama:SetCode(EVENT_ADJUST)
		ama:SetOperation(c101010013.amaop)
		Duel.RegisterEffect(ama,0)
	end
end
function c101010013.amafilter(c)
	return c:GetOriginalCode()==80280737
end
function c101010013.amaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(c101010013.amafilter,c:GetControler(),0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(101010013)==0 then
			--Activate
			local e1=Effect.CreateEffect(tc)
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e1:SetDescription(aux.Stringid(101010013,2))
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
			e1:SetCost(c101010013.cost)
			e1:SetTarget(c101010013.tg)
			e1:SetOperation(c101010013.op)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(101010013,0,0,1)  
		end
		tc=g:GetNext()
	end
end
function c101010013.filter1(c,e,tp)
	return c:IsCode(101010012) and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c101010013.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c101010013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101010013.filter1,1,nil,e,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c101010013.filter1,1,1,nil,e,tp)
	Duel.Release(rg,REASON_COST)
end
function c101010013.filter2(c,e,tp)
	return c:IsCode(101010013) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101010013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010013.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(c101010013.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		tc:CompleteProcedure()
	end
end
function c101010013.splimit(e,se,sp,st)
	if bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then return false end
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c101010013.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function c101010013.atktg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c101010013.cpfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010013.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010013.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101010013.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101010013.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if chk==0 then return not tc1 or not tc2 end
end
function c101010013.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if tc1 and tc2 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c101010013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c101010013.spfilter(c,e,tp)
	return c:IsCode(101010012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010013.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010013.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010013.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010013.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010013.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101010013.psfilter(c,e,tp,lscale,rscale)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and (lv>=lscale and lv<rscale) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c101010013.pscon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c101010013.psfilter,1,nil,e,tp,lscale,rscale)
		else
		return Duel.IsExistingMatchingCard(c101010013.psfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c101010013.psop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,c101010013.psfilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101010013.psfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
end
