--Dimension Birth
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101010255,ACTIVITY_SPSUMMON,ref.ctfilter)
end
function ref.ctfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function ref.cfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and not c:IsImmuneToEffect(e)
end
function ref.filter(c,djn)
	local atk=c:GetAttack()
	local def=c:GetDefence()
	local lv=c:GetLevel()
	local mult=10
	if lv<10 then mult=mult*10 end
	while atk>=1000 do atk=atk/10 end
	local mhb=atk/(lv*mult)
	while mhb<1 do mhb=mhb*10 end
	local mhc=mhb-math.floor(mhb)
	if mhc>=0.5 then mhb=math.ceil(mhb) end
	if math.floor(mhb)~=djn then
		mhb=def/(lv*mult)
		if mhb<1 then mhb=mhb*10 end
		local mhc=mhb-math.floor(mhb)
		if mhc>=0.5 then mhb=math.ceil(mhb) end
	end
	mhb=math.floor(mhb)
	return mhb==djn
end
function ref.sfilter(c,e,tp,m)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ+0x7150,tp,false,false) and m:IsExists(ref.filter,1,nil,c:GetRank())
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,5) and Duel.GetCustomActivityCount(101010255,tp,ACTIVITY_SPSUMMON)==0 end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetLabelObject(e)
	e0:SetTargetRange(1,0)
	e0:SetTarget(ref.sumlimit)
	Duel.RegisterEffect(e0,tp)
	Duel.DiscardDeck(tp,5,REASON_COST)
	local g=Duel.GetOperatedGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
	local mg=g:Filter(ref.cfilter,nil,e)
	if mg:GetCount()==0 then return false end
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local mg=g:Filter(ref.cfilter,nil,e)
	g:DeleteGroup()
	local sg=Duel.GetMatchingGroup(ref.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mc=mg:FilterSelect(tp,ref.filter,1,1,nil,tc:GetRank())
		tc:SetMaterial(mc)
		Duel.Remove(mc,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+0x7150)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ+0x7150,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function ref.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se and c:IsLocation(LOCATION_EXTRA)
end
