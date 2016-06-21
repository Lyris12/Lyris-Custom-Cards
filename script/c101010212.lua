--サイバー・ドラゴン・ジュッぺЯノヴァ
local id,ref=GIR()
function ref.start(c)
c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),-1,3,ref.ovfilter,aux.Stringid(id,0))
	--pendulum summon (regular)
	aux.AddPendulumProcedure(c)
	--invincibility (spell)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCountLimit(2)
	e1:SetValue(ref.value)
	c:RegisterEffect(e1)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--move to Pendulum scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(ref.pentg)
	c:RegisterEffect(e2)
	--detach
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(ref.cost)
	e4:SetTarget(ref.tg)
	e4:SetOperation(ref.op)
	c:RegisterEffect(e4)
	--Яeborn the Nova
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(ref.con)
	e5:SetOperation(ref.rtnop)
	c:RegisterEffect(e5)
	--pendulum summon (special)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC_G)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,id)
	e6:SetCondition(ref.pscon)
	e6:SetOperation(ref.psop)
	e6:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,ref.counterfilter)
end
function ref.counterfilter(c)
	return c:IsRace(RACE_MACHINE)
end
function ref.ovfilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==58069384 and c:GetOverlayCount()==0
end
function ref.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and (not tc1 or not tc2) end
	Duel.MoveToField(c,c:GetControler(),c:GetControler(),LOCATION_SZONE,POS_FACEUP,true)
end
function ref.value(c)
	return (c:GetPreviousLocation()==LOCATION_EXTRA and c:IsRace(RACE_MACHINE)) and c:IsReason(REASON_EFFECT)
end
function ref.psfilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsRace(RACE_MACHINE) and (c:IsLocation(LOCATION_HAND) or (c:IsType(TYPE_PENDULUM))))
	and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,true)
		and not c:IsForbidden()
end
function ref.pscon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:GetSequence()~=6 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if c:IsForbidden() then return false end
	if Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)~=0 then return false end
	if og then
		return og:IsExists(ref.psfilter,1,nil,e,tp,lscale,rscale)
		else
		return Duel.IsExistingMatchingCard(ref.psfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function ref.psop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=og:FilterSelect(tp,ref.psfilter,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,ref.psfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
		sg:Merge(g)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
	local tc=sg:GetFirst()
	while tc do
		if not tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) then
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(ref.splimit)
	Duel.RegisterEffect(e1,tp)
end
function ref.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_MACHINE
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function ref.filter(c,e,tp)
	return c:IsSetCard(0x1093) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and ref.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function ref.mfilter(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0x46) or c:GetActivateEffect():IsHasCategory(CATEGORY_SPECIAL_SUMMON)) and c:IsAbleToHand()
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetFirstTarget()
	if sg and sg:IsRelateToEffect(e) then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,ref.mfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc1=g1:GetFirst()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(1-tp,ref.mfilter,tp,0,LOCATION_DECK,1,1,nil)
			local tc2=g2:GetFirst()
			g1:Merge(g2)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			if tc1 then
				Duel.ConfirmCards(1-tp,tc1)
				tc1:RegisterFlagEffect(id,nil,0,1)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1:SetCode(EVENT_CHAIN_ACTIVATING)
				e1:SetOperation(ref.actop)
				e1:SetLabelObject(tc1)
				Duel.RegisterEffect(e1,tp)
			end
			if tc2 then Duel.ConfirmCards(tp,tc2) end
		end
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e0:SetRange(LOCATION_MZONE)
			e0:SetCode(EFFECT_IMMUNE_EFFECT)
			e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e0:SetValue(ref.efilter)
			c:RegisterEffect(e0)
		end
	end
end
function ref.efilter(e,tp,ep,rp)
	return rp~=tp
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:GetFirst()
	return re:GetActiveType()==TYPE_SPELL and tg:IsControler(1-tp) and tg:IsPreviousLocation(LOCATION_EXTRA)
end
function ref.confilter(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsControlerCanBeChanged()
end
function ref.rtnop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	if ft<=0 then return end
	local cong=Duel.GetMatchingGroup(ref.confilter,tp,0,LOCATION_MZONE,nil,tp)
	local g=eg:Filter(ref.confilter,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.GetControl(tc,tp,0,0)
			Duel.RegisterFlagEffect(tp,id,RESET_EVENT+0x1fe0000,0,1)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
			e0:SetCode(EFFECT_CANNOT_ATTACK)
			e0:SetCondition(ref.catkcon)
			e0:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e0)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetCondition(ref.catkcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local ph=Duel.GetCurrentPhase()
		Duel.BreakEffect()
		if ph<=PHASE_DRAW then
			Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_DRAW,1)
		end
		if ph<=PHASE_MAIN1 then
			Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_MAIN1,1)
		end
		if ph<=PHASE_BATTLE then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		end
		if ph<=PHASE_MAIN2 then
			Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_MAIN2,1)
		end
		Duel.SkipPhase(1-tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	end
end
function ref.catkcon(e)
	return Duel.GetFlagEffect(tp,id)~=0
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or re:GetHandler()~=e:GetLabelObject() then return end
	if e:GetLabelObject():GetFlagEffect(id)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(ref.skipcon)
		end
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
		e:GetLabelObject():ResetFlagEffect(id)
	end
end
function ref.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
