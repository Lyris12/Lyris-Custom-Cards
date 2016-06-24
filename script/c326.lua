--Noise Change
function c326.initial_effect(c)
	if not c326.global_check then
		c326.global_check=true
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(c326.op)
		Duel.RegisterEffect(e2,0)
	end
end
function c326.filterx(c)
	return c.noise_change
end
function c326.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c326.filterx,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(326)==0 then
			if tc:IsType(TYPE_XYZ) then
				local ex=Effect.CreateEffect(tc)
				ex:SetDescription(1063)
				ex:SetType(EFFECT_TYPE_FIELD)
				ex:SetCode(EFFECT_SPSUMMON_PROC)
				ex:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				ex:SetRange(LOCATION_EXTRA)
				ex:SetCountLimit(1,40702060)
				ex:SetCondition(c326.xtscon)
				ex:SetOperation(c326.xtsop)
				ex:SetValue(SUMMON_TYPE_XYZ+0x4726)
				tc:RegisterEffect(ex)
				local ef=Effect.CreateEffect(tc)
				ef:SetDescription(1056)
				ef:SetType(EFFECT_TYPE_FIELD)
				ef:SetCode(EFFECT_SPSUMMON_PROC)
				ef:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				ef:SetRange(LOCATION_EXTRA)
				ef:SetCountLimit(1,40702060)
				ef:SetCondition(c326.fscon)
				ef:SetOperation(c326.fsop)
				ef:SetValue(0x4726)
				tc:RegisterEffect(ef)
			end
			if tc:IsType(TYPE_SYNCHRO) then
				local es=Effect.CreateEffect(tc)
				es:SetDescription(1073)
				es:SetType(EFFECT_TYPE_FIELD)
				es:SetCode(EFFECT_SPSUMMON_PROC)
				es:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				es:SetRange(LOCATION_EXTRA)
				es:SetCountLimit(1,40702060)
				es:SetCondition(c326.stxcon)
				es:SetOperation(c326.stxop)
				es:SetValue(SUMMON_TYPE_SYNCHRO+0x4726)
				tc:RegisterEffect(es)
				local ef=Effect.CreateEffect(tc)
				ef:SetDescription(1056)
				ef:SetType(EFFECT_TYPE_FIELD)
				ef:SetCode(EFFECT_SPSUMMON_PROC)
				ef:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				ef:SetRange(LOCATION_EXTRA)
				ef:SetCountLimit(1,40702060)
				ef:SetCondition(c326.fscon)
				ef:SetOperation(c326.fsop)
				ef:SetValue(0x4726)
				tc:RegisterEffect(ef)
			end
			if tc:IsType(TYPE_FUSION) then
				local er=Effect.CreateEffect(tc)
				er:SetType(EFFECT_TYPE_SINGLE)
				er:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				er:SetCode(EFFECT_SPSUMMON_CONDITION)
				er:SetValue(c326.splimit)
				tc:RegisterEffect(er)
			end
			tc:RegisterFlagEffect(326,RESET_EVENT+EVENT_ADJUST,0,1)  
		end
		tc=g:GetNext()
	end
end
function c326.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c326.spfilter(c,sc)
	local m=_G["c"..sc:GetCode()]
	return m and m.noise_material(c) and c:IsAbleToExtra()
end
function c326.stxcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c326.spfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c326.xmfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c326.stxop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectMatchingCard(tp,c326.spfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(sg)
	local sc=sg:GetFirst()
	local mg=sc:GetMaterial():Filter(c326.xmfilter,nil,sc)
	Duel.SendtoDeck(sg,nil,0,REASON_MATERIAL+0x4726)
	Duel.Overlay(c,mg)
end
function c326.sfilter(c,sc,lv)
	local og=c:GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	if not og:GetCount()==0 then return false end
	local m=_G["c"..sc:GetCode()]
	return m and m.noise_material(c) and og:GetSum(Card.GetLevel)==lv and c:IsAbleToExtra()
end
function c326.xtscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c326.sfilter,tp,LOCATION_MZONE,0,1,nil,c,c:GetLevel())
end
function c326.xtsop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=Duel.SelectMatchingCard(tp,c326.sfilter,tp,LOCATION_MZONE,0,1,1,nil,c,c:GetLevel())
	c:SetMaterial(sg)
	Duel.SendtoDeck(sg,nil,0,REASON_MATERIAL+0x4726)
end
function c326.fsfilter(c,sc,lv)
	local m=_G["c"..c:GetCode()]
	return m and m.noise_material(sc) and c:IsAbleToExtra() and c:IsType(TYPE_FUSION)
end
function c326.fscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	return Duel.IsExistingMatchingCard(c326.fsfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c326.fsop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c326.fsfilter,tp,LOCATION_MZONE,0,1,1,nil,c,c:GetLevel())
	c:SetMaterial(sg)
	Duel.SendtoDeck(sg,nil,0,REASON_MATERIAL+0x4726)
end
